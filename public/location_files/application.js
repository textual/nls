// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function change_rating(to_rating_num, to_rating_text)
{
	
	var rating_element = document.getElementById('reviewer_rating');
	rating_element.setAttribute("class", "rating " + to_rating_text + "star");
	
	// set hidden field value for rating
	var rating_value = document.getElementById('review_rating');
	rating_value.value = to_rating_num;
	
}