class _MenuState : MenuFeed::MenuState_V1 {
    bool _initialized = false;
    string _currPage;
    string _parentPage;
    string PageUID = "MenuState";

    _MenuState() {
        super();
        startnew(CoroutineFunc(this.MainCoro));
    }

    bool get_Initialized() const override {
        return _initialized;
    }

    const string get_CurrentPage() const override {
        return _currPage;
    }

    MLHook::PendingEvent@[] pendingEvents;

    void OnEvent(MLHook::PendingEvent@ event) override {
        pendingEvents.InsertLast(event);
    }

    void MainCoro() {
        while (true) {
            yield();
            for (uint i = 0; i < pendingEvents.Length; i++) {
                ProcessEvent(pendingEvents[i]);
            }
            pendingEvents.RemoveRange(0, pendingEvents.Length);
        }
    }

    void ProcessEvent(MLHook::PendingEvent@ evt) {
        if (evt.type == "Router_RouteUpdated") UpdateRoute(evt);
        else warn("MenuFeed, unknown event: " + evt.type);
    }

    void UpdateRoute(MLHook::PendingEvent@ evt) {
        if (evt.data.Length > 0) {
            _initialized = true;
            _currPage = evt.data[0];
            _parentPage = evt.data.Length > 1 ? string(evt.data[1]) : "";
            print("Set current page: " + _currPage);
            print("Set previous page: " + _parentPage);
        }
    }
}
