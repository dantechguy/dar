#ifndef FLUTTER_PLUGIN_REN_PLUGIN_H_
#define FLUTTER_PLUGIN_REN_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace ren {

class RenPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  RenPlugin();

  virtual ~RenPlugin();

  // Disallow copy and assign.
  RenPlugin(const RenPlugin&) = delete;
  RenPlugin& operator=(const RenPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace ren

#endif  // FLUTTER_PLUGIN_REN_PLUGIN_H_
