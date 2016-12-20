
jQuery(document).ready(function(){
//	jQuery("#ukasky_livecontact").click(function(){
//		if(jQuery('#aFloatTools_Hide').css('display')!='none'){
//			jQuery('#divFloatToolsView').stop(false,true).animate({width: 'hide', opacity: 'hide'}, 'normal',function(){ jQuery('#divFloatToolsView').hide(); });
//		}else{
//			jQuery('#divFloatToolsView').stop(false,true).animate({width: 'show', opacity: 'show'}, 'normal',function(){ jQuery('#divFloatToolsView').show(); });
//		}
//		jQuery('#aFloatTools_Hide').toggle();
//		jQuery('#aFloatTools_Show').toggle();
//	});
	jQuery('#aFloatTools_Hide').click(function(){
		jQuery('#divFloatToolsView').stop(false,true).animate({width: 'hide', opacity: 'hide'}, 'normal',function(){ jQuery('#divFloatToolsView').hide(); });
		jQuery('#aFloatTools_Hide').toggle();
		jQuery('#aFloatTools_Show').toggle();
	});
	jQuery("#aFloatTools_Show").click(function(){
		jQuery('#divFloatToolsView').stop(false,true).animate({width: 'show', opacity: 'show'}, 'normal',function(){ jQuery('#divFloatToolsView').show(); });
		jQuery('#aFloatTools_Hide').toggle();
		jQuery('#aFloatTools_Show').toggle();
	});
});
