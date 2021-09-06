package ssa.ssa;

import net.dv8tion.jda.api.JDA;
import org.bukkit.plugin.java.JavaPlugin;

import java.sql.Connection;
import java.util.Properties;

public final class Ssa extends JavaPlugin {
    static JDA discord;
    @Override
    public void onEnable() {
        // Plugin startup logic
        System.out.println("Greetings!");
        getServer().getPluginManager().registerEvents(new Listeners(), this);
        Settings.load();
        System.out.println("Complete");
    }

    @Override
    public void onDisable() {
        // Plugin shutdown logic
    }
}
