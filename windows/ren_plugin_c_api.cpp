#include "include/ren/ren_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "ren_plugin.h"

void RenPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  ren::RenPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
