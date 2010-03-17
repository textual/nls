// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function change_rating(to_rating_num, to_rating_text)
{
	
	var rating_element = document.getElementById('reviewer_rating');
	rating_element.setAttribute("class", "rating " + to_rating_text + "star");
	
	// set hidden field value for rating
	var rating_value = document.getElementById('review_rating');
	rating_value.value = to_rating_num;
	
	var submit_button = document.getElementById('review_submit');
	submit_button.disabled = false;
	
}
jQuery.ajaxSetup({
	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
	this.submit(function() {
		$.post($(this).attr("action"), $(this).serialize(), null, "script");
		return false;
	})
};

$(document).ready(function () {
	$("#new_user").validate({
		    rules: {
			  "user[login]": {required: true},
		      "user[email]": {required: true, email: true},
			  "user[password]": {required: true, minlength: 6},
			  "user[password_confirmation]": {required: true, equalTo: "#user_password"}
			}
	});
	
	$("#new_session").validate({
		    rules: {
			  "login": {required: true},
			  "password": {required: true},
			}
	});
	
	$("#new_review").validate({
			
			
		    rules: {
			 "review[comment]":{required:true}
			}
	});	
	
	$("#new_review").submitWithAjax();
	
	
	
});