package ssa.ssa;

import org.bukkit.Bukkit;
import org.bukkit.Location;
import org.bukkit.Material;
import org.bukkit.World;
import org.bukkit.block.Block;
import org.bukkit.entity.EntityType;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.block.BlockBreakEvent;
import org.bukkit.event.entity.EntityDamageEvent;
import org.bukkit.event.player.PlayerAnimationEvent;
import org.bukkit.event.player.PlayerLoginEvent;
import org.bukkit.event.player.PlayerMoveEvent;
import org.bukkit.event.server.PluginEnableEvent;

public class Listeners implements Listener {
    @EventHandler
    public void onLogin(PlayerLoginEvent loginEvent) {
        loginEvent.setKickMessage("Kicking for no reason at all");
    }

    @EventHandler
    public void onDestroy(BlockBreakEvent breakEvent) {
        System.out.println("Evt catch");
        Block block = breakEvent.getBlock();
        breakEvent.getPlayer().chat("No breaking blocks!");
        World world = Bukkit.getServer().getWorld("world");
        assert world != null;
        world.setTime(0);
        world.setStorm(false);
        breakEvent.setCancelled(true);
    }

    @EventHandler
    public void onMove(PlayerMoveEvent moveEvent) {
        Location loc = moveEvent.getPlayer().getLocation().clone().subtract(0,1,0);
    }
    

    @EventHandler
    public void onStart(PluginEnableEvent enableEvent) {
        System.out.println("Event Has started");
    }
}
