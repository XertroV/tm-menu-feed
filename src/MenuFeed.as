namespace MenuFeed {
    const string get_ParentPage() { return menuStateFeed.ParentPage; }
    const string get_CurrentPage() { return menuStateFeed.CurrentPage; }
    bool get_PageChanged() { return menuStateFeed.PageChanged; }
}

_MenuState@ menuStateFeed = _MenuState();

class _MenuState : MLHook::HookMLEventsByType {
    bool _initialized = false;
    string _currPage;
    string _parentPage;
    string PageUID = "MenuState";
    bool PageChanged = false;

    _MenuState() {
        super("Router_RouteUpdated");
        startnew(CoroutineFunc(this.MainCoro));
    }

    bool get_Initialized() const {
        return _initialized;
    }

    const string get_CurrentPage() const {
        return _currPage;
    }

    const string get_ParentPage() const {
        return _parentPage;
    }

    MLHook::PendingEvent@[] pendingEvents;

    void OnEvent(MLHook::PendingEvent@ event) override {
        pendingEvents.InsertLast(event);
    }

    void MainCoro() {
        while (true) {
            yield();
            PageChanged = false;
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
            PageChanged = true;
            // trace("Set current page: " + _currPage);
            // trace("Set previous page: " + _parentPage);
        }
    }
}
