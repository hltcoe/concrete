function addConcreteNavigation() {
  $("td").filter(function() {
    return $(this).text().trim() == 'required';
  }).addClass('concreteRequired');
  $("td").filter(function() {
    return $(this).text().trim() == 'optional';
  }).addClass('concreteOptional');
  $("table").tablesorter({'sortInitialOrder':'desc'});
  $('.table-condensed th').css('padding-left','25px');

  var concrete_filelist_ul = $('<ul>');
  for (var i=0, l=CONCRETE_FILELIST.length; i<l; i++) {
    concrete_filelist_ul.append(
      $('<li>').html('<a href="' + CONCRETE_FILELIST[i] + '.html">' + CONCRETE_FILELIST[i] + '</a>'));
  }

  $('body div.container-fluid').before(
    $('<div>')
      .addClass("leftPane")
      .append(
        $('<h1>').html("Concrete Types"))
      .append(concrete_filelist_ul));
  $('body div.container-fluid').addClass('rightPane');
}
