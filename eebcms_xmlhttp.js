var _____WB$wombat$assign$function_____ = function(name) {return (self._wb_wombat && self._wb_wombat.local_init && self._wb_wombat.local_init(name)) || self[name]; };
if (!self.__WB_pmw) { self.__WB_pmw = function(obj) { this.__WB_source = obj; return this; } }
{
  let window = _____WB$wombat$assign$function_____("window");
  let self = _____WB$wombat$assign$function_____("self");
  let document = _____WB$wombat$assign$function_____("document");
  let location = _____WB$wombat$assign$function_____("location");
  let top = _____WB$wombat$assign$function_____("top");
  let parent = _____WB$wombat$assign$function_____("parent");
  let frames = _____WB$wombat$assign$function_____("frames");
  let opener = _____WB$wombat$assign$function_____("opener");

/*=====================================*\
|| ################################### ||
|| #                                 # ||
|| #      EEBCMS xmlHTTP Handler     # ||
|| #                                 # ||
|| ################################### ||
\*=====================================*/

function xmlHTTP_Send(handlerData, method, callbackFunc, requestData) {

    xmlHTTP_Data = handlerData;
    
    if (xmlHTTP_Locked) {
        return false;
    }
    if (xmlHTTP_Active >= xmlHTTP_Max_Active) {
        xmlHTTP_Message(xmlHTTP_Data.String_buffer_full);
        return false;
    }
    if (callbackFunc == "test") {
        xmlHTTP_Message(xmlHTTP_Data.String_loading.replace(/%s/, 'Test'));
    }
    try {
        var xmlHTTP = new XMLHttpRequest();
        if (callbackFunc == "test") {
            xmlHTTP_systemMessage("Trying to test XMLHttpRequest ...");
        } else {
            xmlHTTP_systemMessage("Trying to init XMLHttpRequest ...");
        }
    } catch (error) {
        xmlHTTP_systemMessage("... failed !!!");
        try {
            var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
            if (callbackFunc == "test") {
                xmlHTTP_systemMessage("Trying to test Microsoft.XMLHTTP ...");
            } else {
                xmlHTTP_systemMessage("Trying to init Microsoft.XMLHTTP ...");
            }
        } catch (error) {
            xmlHTTP_systemMessage("... failed !!!");
            xmlHTTP_Message(xmlHTTP_Data.String_error_init);
            xmlHTTP_Locked = 1;
            return false;
        }
    }
    xmlHTTP_systemMessage("... success !");
    if (callbackFunc == "test") {
        xmlHTTP_Message(xmlHTTP_Data.String_ready);
        return true;
    }
    xmlHTTP_systemMessage("Define stateHandler");

    function xmlHTTP_StateHandler() {
        xmlHTTP_systemMessage("State changed to: " + xmlHTTP.readyState);
        if (xmlHTTP.readyState == 4) {
            xmlHTTP_systemMessage("Got HTTP-Code " + xmlHTTP.status);
            if (xmlHTTP.status == 200) {
                xmlHTTP_systemMessage("Starting callback");
                eval(callbackFunc + "(xmlHTTP.responseText, xmlHTTP.responseXML);");
                xmlHTTP_Active --;
                if (!xmlHTTP_Locked) {
                    if (xmlHTTP_Active == 0) {
                        xmlHTTP_Message(xmlHTTP_Data.String_ready);
                    } else {
                        xmlHTTP_Message(xmlHTTP_Data.String_loading.replace(/%s/, xmlHTTP_Active));
                    }
                }
                xmlHTTP_systemMessage("Finshed ! - Shutting down ...");
                xmlHTTP_systemMessage("");
                return true;
            } else {
                xmlHTTP_systemMessage(xmlHTTP_Data.String_error_status.replace(/%s/, xmlHTTP.status));
                xmlHTTP_Locked = 1;
                return false;
            }
        }
    }

    xmlHTTP_Active ++;
    xmlHTTP_Message(xmlHTTP_Data.String_loading.replace(/%s/, xmlHTTP_Active));
    xmlHTTP_systemMessage("Prepare request");
    xmlHTTP.open(method, xmlHTTP_Data.URL, true, xmlHTTP_Data.AuthUser, xmlHTTP_Data.AuthPass);
    if (method == "POST") {
        xmlHTTP.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    }
    xmlHTTP_systemMessage("Send request");
    xmlHTTP.send(requestData);
    xmlHTTP_systemMessage("Waiting for response ...");
    xmlHTTP.onreadystatechange = xmlHTTP_StateHandler;
    return true;
}


function xmlHTTP_Message(text) {
    if (xmlHTTP_Data.MessageElem && text) {
        xmlHTTP_Data.MessageElem.innerHTML = text;
    }
}


function xmlHTTP_systemMessage(text) {
    if (xmlHTTP_Data.sysMessageElem) {
        if (text == ""){
            xmlHTTP_Data.sysMessageElem.innerHTML = "";
        } else {
            xmlHTTP_Data.sysMessageElem.innerHTML = xmlHTTP_Data.sysMessageElem.innerHTML+"<br />\r\n"+text;
        }
    }
    return;
}

if (typeof(xmlHTTP_Active) == 'undefined') {
    var xmlHTTP_Active = 0;
    var xmlHTTP_Max_Active = 3;
    var xmlHTTP_Locked;
}

}
/*
     FILE ARCHIVED ON 02:51:32 May 06, 2012 AND RETRIEVED FROM THE
     INTERNET ARCHIVE ON 17:13:43 Aug 24, 2024.
     JAVASCRIPT APPENDED BY WAYBACK MACHINE, COPYRIGHT INTERNET ARCHIVE.

     ALL OTHER CONTENT MAY ALSO BE PROTECTED BY COPYRIGHT (17 U.S.C.
     SECTION 108(a)(3)).
*/
/*
playback timings (ms):
  captures_list: 0.423
  exclusion.robots: 0.014
  exclusion.robots.policy: 0.006
  esindex: 0.008
  cdx.remote: 13.219
  LoadShardBlock: 945.713 (3)
  PetaboxLoader3.datanode: 59.461 (4)
  PetaboxLoader3.resolve: 1363.081 (3)
  load_resource: 506.476
*/