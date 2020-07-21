package com.hb.wobei

import android.annotation.SuppressLint
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.util.Log
import android.widget.Toast
import com.amap.api.location.AMapLocation
import com.tbruyelle.rxpermissions2.RxPermissions
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val CHANNEL = "samples.flutter.io/common"

    //创建MethodChannel并设置一个MethodCallHandler。确保使用与在Flutter客户端使用的通道名称相同。
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        ToastProviderPlugin.register(this, flutterEngine.dartExecutor.binaryMessenger)
        AMapProviderPlugin.register(this, flutterEngine.dartExecutor.binaryMessenger)
        LogProviderPlugin.register(flutterEngine.dartExecutor.binaryMessenger)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "toast"->{
                    toast(call.argument<String>("text").toString())
                }
                "logD"->{
                    logD(call.argument<String>("tag").toString(), call.argument<String>("text").toString())
                }
                "goToWebView"->{
                    goToWebView(call.argument<String>("url").toString())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

    }

    fun goToWebView(url : String){
        HeBeiHtmlActivity.start(this, url);
    }

    fun toast(text:String){
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show()
    }

    fun logD(tag:String, text: String){
        Log.d(tag, text)
    }

}