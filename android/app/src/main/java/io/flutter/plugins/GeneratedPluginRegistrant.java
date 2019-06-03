package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import be.appmire.flutterkeychain.FlutterKeychainPlugin;
import com.flutter_webview_plugin.FlutterWebviewPlugin;
import io.flutter.plugins.share.SharePlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FlutterKeychainPlugin.registerWith(registry.registrarFor("be.appmire.flutterkeychain.FlutterKeychainPlugin"));
    FlutterWebviewPlugin.registerWith(registry.registrarFor("com.flutter_webview_plugin.FlutterWebviewPlugin"));
    SharePlugin.registerWith(registry.registrarFor("io.flutter.plugins.share.SharePlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
