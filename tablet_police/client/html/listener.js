$(function(){
	window.onload = (e) => {
        $("#container").hide();
		window.addEventListener('message', (event) => {
            //document.querySelector("#logo").innerHTML = " "
			var item = event.data;
			if (item !== undefined && item.type === "ui") {
				if (item.display === true) {
                    $("#container").show();
					$("#taryfikator_main").hide();
					$("#menu_result_tary").hide();
					$("#menu_mandat").hide();
					$("#menu_wiezienie").hide();
					$("#finded_person_menu").hide();
					$("#search_menu").hide();
				} else{
                    $("#container").hide();
                }

			}
			if (item !== undefined && item.type == 'reset_persons')
				{
					var a = document.getElementById('persons_closest') ;
					var f = a.firstElementChild;
					var b = document.getElementById('persons_closest_2') ;
					var f2 = b.firstElementChild;
						while (f || f2) {
							if (f) {
								f.remove();
								f = a.firstElementChild;
							}
							if (f2) {
								f2.remove();
								f2 = b.firstElementChild;
							}
						}
				}
				if (item !== undefined && item.type == 'add_person')
				{
					$('#persons_closest').append(`<option> ${item.id} </option>`);
					$('#persons_closest_2').append(`<option> ${item.id} </option>`);
				}
				if (item !== undefined && item.type == 'finded')
				{
$("#search_menu").hide();

document.getElementById("weapon_license").className = item.w;
document.getElementById("dmv").className = item.d;

document.getElementById("user_birth").innerHTML = item.b;
document.getElementById("user_height").innerHTML= item.h;
document.getElementById("user_sex").innerHTML = item.s;

document.getElementById("Name_u").innerHTML = $("#user_name").val();

$("#finded_person_menu").show();

				}
		});
	};
});

function uncheckElements()
{
 var uncheck=document.getElementsByTagName('input');
 for(var i=0;i<uncheck.length;i++)
 {
  if(uncheck[i].type=='checkbox')
  {
   uncheck[i].checked=false;
  }
  if (uncheck[i].type=='number') {
uncheck[i].value = 1;
  }
 }

}



$(document).ready(function() {
	var reason_tary = "";
	var reasonz_tary = "";
	let grzywna_tary = 0;
	let lat_tary = 0;

	$("#auto_tary_btn").click(function()
{
	$.post('http://tablet_police/get_persons', JSON.stringify({}));

$("#taryfikator_main").hide();
	$("#menu_wiezienie").hide();
	$("#search_menu").hide();
	$("#menu_result_tary").hide();
	$("#finded_person_menu").hide();
if (lat_tary <= 0) {
	document.getElementById("mandat_reason").value = reason_tary;
	document.getElementById("mandat_grzywna").value = grzywna_tary;
	$("#menu_mandat").show();
}
else {
	document.getElementById("jail_reason").value = reason_tary;
	document.getElementById("jail_grzywna").value = grzywna_tary;
	document.getElementById("jail_lat").value = lat_tary;
	$("#menu_wiezienie").show();
}
	
});
$("#show_tary_btn").click(function(){
	$.post('http://tablet_police/show_kare', JSON.stringify({kara: reasonz_tary.toString()}));
});

	$("#taryfikator_result").click(function(){
		var podpunkty = [];
		var podpunktybez = [];
		let grzywna = 0;
		let lat = 0;


		$.each($("input[type=checkbox][id*=_taryfikator]:checked"), function(){
			 var m = $(this).closest("label").find('#multiplier');
		lat = lat + (parseInt($(this).val())*m.val());
		grzywna = grzywna + (parseInt($(this).attr("data-valuetwo"))*m.val());
		if (m.val() > 1) {
			podpunktybez.push($(this).attr("data-valuethree") + ` ${m.val()}x`) ;
			podpunkty.push($(this).attr("data-valuethree") + ` ${m.val()}x`) ;
	
		}  else {
			podpunkty.push($(this).attr("data-valuethree"));
			podpunktybez.push($(this).attr("data-valuethree"));
		}
		
		});
		reason_tary = podpunktybez;
		reasonz_tary = podpunkty;
		grzywna_tary = grzywna;
		lat_tary = lat;

		uncheckElements()
		podpunkty.push(` Grzywna: ${grzywna}$ | Kara pozbawienia wolności: ${lat} lat `)
			
		document.getElementById('result_taryfikator').value = podpunkty;
		$("#taryfikator_main").hide();
		$("#menu_result_tary").show();

	});

});