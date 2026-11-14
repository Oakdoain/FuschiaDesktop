package com.fuschia.leverlight;

import net.minecraft.world.effect.MobEffectInstance;
import net.minecraft.world.effect.MobEffects;
import net.minecraft.world.item.CreativeModeTabs;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.event.BuildCreativeModeTabContentsEvent;
import net.minecraftforge.event.TickEvent;
import net.minecraftforge.eventbus.api.IEventBus;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.ForgeRegistries;
import net.minecraftforge.registries.RegistryObject;

/**
 * Forge 1.20.1 - One item only: the Control Lever.
 *
 * This is an ordinary Item (NOT a BlockItem), so it cannot place a block.
 * Its model inherits the vanilla Minecraft lever item model.
 * Optional dynamic lighting is supplied as data for OptiFine/RyoamicLights.
 */
@Mod(LeverLightMod.MOD_ID)
public final class LeverLightMod {
    public static final String MOD_ID = "leverlight";

    private static final DeferredRegister<Item> ITEMS =
            DeferredRegister.create(ForgeRegistries.ITEMS, MOD_ID);

    public static final RegistryObject<Item> CONTROL_LEVER = ITEMS.register(
            "control_lever", () -> new Item(new Item.Properties().stacksTo(64))
    );

    public LeverLightMod() {
        IEventBus modBus = FMLJavaModLoadingContext.get().getModEventBus();
        ITEMS.register(modBus);
        modBus.addListener(this::addToCreativeTab);
        MinecraftForge.EVENT_BUS.register(this);
    }

    private void addToCreativeTab(BuildCreativeModeTabContentsEvent event) {
        if (event.getTabKey() == CreativeModeTabs.TOOLS_AND_UTILITIES) {
            event.accept(CONTROL_LEVER);
        }
    }

    /**
     * Check all player inventory slots, including main hand, offhand and armor.
     * A 3-second, level-1 effect is refreshed every second while the item is held.
     * A stronger Speed effect is never downgraded.
     * We deliberately do not remove potion effects on item loss, because the
     * player may have received Speed from other vanilla/modded sources.
     */
    @SubscribeEvent
    public void onPlayerTick(TickEvent.PlayerTickEvent event) {
        if (event.phase != TickEvent.Phase.END || event.player.level().isClientSide()) {
            return;
        }
        if (event.player.tickCount % 20 != 0) {
            return;
        }

        boolean ownsControlLever = false;
        for (int slot = 0; slot < event.player.getInventory().getContainerSize(); ++slot) {
            ItemStack stack = event.player.getInventory().getItem(slot);
            if (stack.is(CONTROL_LEVER.get())) {
                ownsControlLever = true;
                break;
            }
        }
        if (!ownsControlLever) {
            return;
        }

        MobEffectInstance speed = event.player.getEffect(MobEffects.MOVEMENT_SPEED);
        if (speed == null || (speed.getAmplifier() == 0 && speed.getDuration() <= 40)) {
            event.player.addEffect(new MobEffectInstance(
                    MobEffects.MOVEMENT_SPEED, 60, 0, true, false, true
            ));
        }
    }
}
