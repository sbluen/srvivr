// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.chrono
//= require_tree .

$(document).ready(function() {
	$('a.remove_item').each(function(){$(this).bind('ajax:before', function() {
		$(this).closest('tr').fadeOut();
		$('span#friendcount').text(parseInt($('span#friendcount').text())-1);
	})});

	$('a.set_cell_to_invited').each(function(){$(this).bind('ajax:before', function() {
		$(this).closest('td#invite_link').text('Invited');
	})});
	$('a.set_cell_to_removed').each(function(){$(this).bind('ajax:before', function() {
		$(this).closest('td#invite_link').text('Removed');
	})});
	$('a.update_report_link').each(function(){$(this).bind('ajax:before', function() {
		$(this).closest('td#report_link').text('Reported');
	})});
	$('a.remove_row').each(function(){$(this).bind('ajax:before', function() {
		$(this).closest('tr').fadeOut();
	})});
});