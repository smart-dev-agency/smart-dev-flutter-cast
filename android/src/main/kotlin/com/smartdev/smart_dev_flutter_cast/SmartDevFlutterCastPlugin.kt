package com.smartdev.smart_dev_flutter_cast

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** SmartDevFlutterCastPlugin */
class SmartDevFlutterCastPlugin : FlutterPlugin, ActivityAware {
    private lateinit var chromeCastFactory: ChromeCastFactory

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // Asegúrate de que ChromeCastFactory se inicialice aquí si aún no lo está.
        // Esta es la inicialización original que tenías.
        if (!this::chromeCastFactory.isInitialized) {
            chromeCastFactory = ChromeCastFactory(binding.binaryMessenger)
        }
        binding.platformViewRegistry.registerViewFactory(
            "ChromeCastButton",
            chromeCastFactory
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // Limpia los recursos relacionados con el motor si es necesario.
        // Por ejemplo, si chromeCastFactory necesita algún tipo de dispose().
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        // onAttachedToEngine se llama antes que esto, por lo que chromeCastFactory debería estar inicializada.
        // Si chromeCastFactory necesita la actividad, asígnala aquí.
        if (this::chromeCastFactory.isInitialized) {
            chromeCastFactory.activity = binding.activity
        }
    }

    override fun onDetachedFromActivity() {
        // Limpia los recursos relacionados con la actividad.
        // Es una buena práctica anular la referencia a la actividad si chromeCastFactory la retiene.
        // if (this::chromeCastFactory.isInitialized) {
        //     chromeCastFactory.activity = null // Asegúrate de que ChromeCastFactory maneje esto.
        // }
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        // Restaura el estado de la actividad si es necesario.
        if (this::chromeCastFactory.isInitialized) {
            chromeCastFactory.activity = binding.activity
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        // La actividad se destruirá y se volverá a crear en breve debido a un cambio de configuración.
        // Normalmente no se necesita una limpieza extensa aquí si se maneja en onDetachedFromActivity
        // o los recursos se restauran en onReattachedToActivityForConfigChanges.
    }
}
