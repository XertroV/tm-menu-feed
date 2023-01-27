namespace MenuFeed {
    shared class MenuState_V1 : MLHook::HookMLEventsByType {
        MenuState_V1() { super("Router_RouteUpdated"); }
        bool get_Initialized() const { return false; }
        const string get_CurrentPage() const { return ""; }
    }
}
