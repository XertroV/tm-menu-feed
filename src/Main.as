void Main() {
    MLHook::RequireVersionApi("0.4.0");
    MLHook::RegisterMLHook(menuStateFeed, menuStateFeed.type, true);

    MLHook::InjectManialinkToMenu("TestPage", """
 #Const C_PageUID "MenuState"

Void MLHookLog(Text msg) {
    SendCustomEvent("MLHook_LogMe_" ^ C_PageUID, [msg]);
}

Void CheckIncoming() {
    declare Text[][] MLHook_Inbound_MenuState for LocalUser;
    foreach (Event in MLHook_Inbound_MenuState) {
        if (Event[0] == "Ping") {
            MLHookLog("Pong: " ^ Event[1]);
        } else {
            MLHookLog("Skipped unknown incoming event: " ^ Event);
            continue;
        }
        MLHookLog("Processed Incoming Event: "^Event[0]);
    }
    MLHook_Inbound_MenuState = [];
}

main() {
    MLHookLog("Starting: "^Now);
    while (True) {
        yield;
        CheckIncoming();
    }
}
    """, true);
}

void PingCoro() {
    while (true) {
        yield();
        // MLHook::Queue_MessageManialinkMenu(menuStateFeed.PageUID, {"Ping", tostring(Time::Now)});
    }
}

void Notify(const string &in msg) {
    UI::ShowNotification(Meta::ExecutingPlugin().Name, msg);
    trace("Notified: " + msg);
}

void NotifyError(const string &in msg) {
    warn(msg);
    UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Error", msg, vec4(.9, .3, .1, .3), 15000);
}

void NotifyWarning(const string &in msg) {
    warn(msg);
    UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Warning", msg, vec4(.9, .6, .2, .3), 15000);
}
