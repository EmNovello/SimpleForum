(function () {
    function handleBeforeUnload(event) {
        event.preventDefault();
        event.returnValue = '';
    }

    window.addEventListener('beforeunload', handleBeforeUnload);
})();