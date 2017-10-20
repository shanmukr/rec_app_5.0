// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree 

//= require bootstrap
//= require jquery-ui   
//= require autocomplete-rails

//= require moment
//= require bootstrap-datetimepicker
//= require bootstrap-datepicker

function auto_complete_for_emp_names_at_req_cont() {
  $("#search").autocomplete({source: empNames["listedEmployees"]});
} 

function auto_complete_for_emp_names_at_resumes_mesg() {
  $("#emp_name").autocomplete({source: empNames["listedEmployees"]});
}

function auto_complete_for_emp_names_at_resumes_interviews() {
  $("#emp_name").autocomplete({source: empNames["listedEmployees"]});
}

function auto_hide_the_fields(e, tr_id, action){
	e.preventDefault();
  $("#hide").hide();
	$("#change_"+tr_id).html(action); 
	return true;
}

function datepicker_1(e){
  e.preventDefault();
  // $(".datepicker").datepicker({format: 'yyyy-mm-dd', autoclose: true, minDate: 0});
  $(".datepicker1").datepicker({format: 'mm-dd-yyyy', autoclose: true, minDate: 0});
}

function resume_action(e, i, j, k, l) {
  e.preventDefault();
  var interview_reqs = $("#forward_req_ids_"+i).val();  
  alert(interview_reqs.length);
  if (interview_reqs.length !== 0){
    $.ajax({
            data:{ req_id: interview_reqs, resume: j , r_status: l }, 
	          type: "post", 
	          url: k,
		        dataType: "script" 
           });
	}
}

function interview_action(e, i, j, k, l, m) {
  e.preventDefault();
  var holded_reqs = $("#forward_req_ids_"+i).val();  
  alert(holded_reqs.length);
  if (holded_reqs.length !== 0){
    $.ajax({
            data:{ req_id: holded_reqs, resume: j , r_status: m, i_status: l }, 
	          type: "post", 
	          url: k,
		        dataType: "script" 
           });
  }
}

