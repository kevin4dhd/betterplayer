package com.jhomlala.better_player

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.util.Log
import android.view.View
import androidx.mediarouter.app.MediaRouteButton
import com.google.android.gms.cast.framework.*
import com.google.android.gms.common.api.PendingResult
import com.google.android.gms.common.api.Status
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView

class ChromeCastController internal constructor(
    val binaryMessenger: BinaryMessenger,
    val viewId: Int,
    val context: Context?
) : SessionManagerListener<Session?>, PlatformView, MethodCallHandler,
    PendingResult.StatusListener {
    var methodChannel: MethodChannel
    var mediaRouteButton: MediaRouteButton
    var sessionManager: SessionManager
    override fun onSessionStarting(session: Session?) {}
    override fun onSessionStarted(session: Session?, s: String) {
        methodChannel.invokeMethod("chromeCast#didStartSession", null)
    }

    override fun onSessionStartFailed(session: Session?, i: Int) {}
    override fun onSessionEnding(session: Session?) {}
    override fun onSessionEnded(session: Session?, i: Int) {
        methodChannel.invokeMethod("chromeCast#didEndSession", null)
    }

    override fun onSessionResuming(session: Session?, s: String) {}
    override fun onSessionResumed(session: Session?, b: Boolean) {}
    override fun onSessionResumeFailed(session: Session?, i: Int) {}
    override fun onSessionSuspended(session: Session?, i: Int) {}
    override fun onComplete(status: Status) {}
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "chromeCast#click") {
            Log.d("ChromeCast", "CLICK CALLED")
            mediaRouteButton.performClick()
            result.success(null)
        }
    }

    override fun getView(): View {
        return mediaRouteButton
    }

    override fun onFlutterViewAttached(flutterView: View) {}
    override fun onFlutterViewDetached() {}
    override fun dispose() {}
    override fun onInputConnectionLocked() {}
    override fun onInputConnectionUnlocked() {}

    init {
        methodChannel = MethodChannel(binaryMessenger, "flutter_video_cast/chromeCast_$viewId")
        mediaRouteButton = MediaRouteButton(context)
        mediaRouteButton.setRemoteIndicatorDrawable(ColorDrawable(Color.TRANSPARENT))
        sessionManager = CastContext.getSharedInstance()!!.sessionManager
        CastButtonFactory.setUpMediaRouteButton(context, mediaRouteButton)
        methodChannel.setMethodCallHandler(this)
        Log.d("ChromeCast", "Controller created for id$viewId")
    }
}