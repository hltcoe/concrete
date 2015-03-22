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

  var str_conc_ver = ""+CONCRETE_VERSION;
  left_pane_html = (str_conc_ver).trim().length > 0 ? 
    "Concrete v" + str_conc_ver.trim() + " Types" :
    "Concrete Types";

  $('body div.container-fluid').before(
    $('<div>')
      .addClass("leftPane")
      .append(
        $('<h1>').html(left_pane_html))
      .append(concrete_filelist_ul));
  $('body div.container-fluid').addClass('rightPane');
}
