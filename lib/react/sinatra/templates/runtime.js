(function() {
  var result = ReactDOMServer.%{render_function}(React.createElement(%{component}, %{props}));
  return result;
})()
