foo(
  "demo",
  {
    title: "Demo",
    width: 100
  },
  function () {
    object.firstCall({
      a: 'a',
      b: 'b'
    })
      .secondCall();
  }
);