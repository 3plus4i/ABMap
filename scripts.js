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

function startUp() {
    OP = (window.opera) ? 1 : 0;
    IE = (!OP && (document.all || window.navigator.userAgent.toLowerCase().indexOf('msie') != -1)) ? 1 : 0;
    NS4 = (document.layers) ? 1 : 0; 
    DOM = (document.getElementById && !IE) ? 1 : 0;

    pointerDrag = false;
    locked = true;
    time = new Date();
    year = time.getFullYear();
    time.setYear(year + 1);
    expires = time.toGMTString();

    time = new Date();
    then = time.getTime() + (86400 * 3 * 1000);
    time.setTime(then);
    expires2 = time.toGMTString();

    mouse_x = mouse_y = 0;
    
    elem = document.getElementById("welcome");
    
    elem.style.filter = 'alpha(opacity=90)'; 
    elem.style.MozOpacity = 0.9;
    elem.style.opacity = 0.9;

    xmlHTTP_ABMapData = {
        MessageElem : document.getElementById('data_box'),
        sysMessageElem : null,
        URL : '/map2.php?layer=js',
        String_error_init : 'Your browser does not support a necessary feature. Please use a modern browser like IE6 or Mozilla Firefox !',
        String_error_status : 'Unable to load data. Server sent response code %s !',
        String_error_default : 'There occured a unknown error !',
        String_error_buffer_full : '',
        String_loading : '',
        String_ready : '',
        AuthUser : '',
        AuthPass : ''
    }

    if (xmlHTTP_Send(xmlHTTP_ABMapData, '', 'test', '')) {
        xmlHTTP_ABMapData.MessageElem.innerHTML = '';
        locked = false;
    }

    setOpacity();
    changeSize(2);
    
    elem = document.getElementById("opacity3");
    elem.onmouseout  = opacHandler;
    elem.onmousemove = opacHandler;
    elem.onmousedown = opacHandler;
    elem.onmouseup   = opacHandler;
    elem.onclick     = opacHandler;

    merch_trans = { 
        "SHC"             : "Solid Hydrogen Capsule",
        "GENERATOR_V2"    : "Generator V2",
        "GENERATOR_V3"    : "Generator V3",
        "GENERATOR_V4"    : "Generator V4",
        "GENERATOR_V5"    : "Generator V5",
        "GENERATOR_V6"    : "Generator V6",
        "MISSILE1"        : "Extra Missile #1",
        "MISSILE2"        : "Extra Missile #2",
        "MISSILE3"        : "Extra Missile #3",
        "CAPSULE_GLACIAL" : "Ice Capsule",
        "CAPSULE_FIRE"    : "Fire Capsule",
        "CAPSULE_VOLT"    : "Volt Capsule",
        "CAPSULE_QUASAR"  : "Quasar Capsule",
        "SECURE_ENVELOPE" : "Extra Life",
        "MISSILE_MAP"     : "Misslie Map",
        "SUNGLASSES"      : "Sunglasses",
        "KIWI_ANTENNE"    : "Ki-Wi Antenna",
        "SIDE_REACTORS"   : "Side Reactors",
        "LIQUID_COOLER"   : "Liquid Cooler",
        "PERPETUAL"       : "Perpetual Synthesis Engine",
        "POD_STANDARD"    : "Pod Extension Standard",
        "POD_SPECIAL"     : "Pod Extension Special",
        "POD_ULTIMATE"    : "Pod Extension Ultimate",
        "DRONE1"          : "Drone #1",
        "DRONE2"          : "Drone #2",
        "DRONE3"          : "Drone #3",
        "DRONE4"          : "Drone #4",
        "DRONE5"          : "Drone #5",
        "DRONE6"          : "Drone #6",
        "DRONE7"          : "Drone #7",
        "DRONE8"          : "Drone #8",
        "DRONE9"          : "Drone #9",
        "DRONE10"         : "Drone #10",
        "PERFORATION"     : "Perforation Tools",
        "COLLECTOR"       : "Collector",
        "SUPP_REACTOR"    : "Support Reactor",
        "CONVERTER"       : "Converter",
        "SURF_REACTOR1"   : "Suface Turbo X1",
        "SURF_REACTOR2"   : "Suface Turbo X2",
        "SURF_REACTOR3"   : "Suface Turbo X3",
        "MINE1"           : "Mine #1",
        "MINE2"           : "Mine #2",
        "MINE3"           : "Mine #3"
    }

    obj_trans = {
        "ambro-x"      : "Ambro-X<br />(Radar upgrade)",
        "anti-radar"   : "Anti radar asteroids",
        "antimatter"   : "Antimatter nuclei",
        "asphalt"      : "Project 'Asphalt' Ball",
        "blue"         : "Blue crystal in the house",
        "crystal"      : "One of five pink crystals<br />for AR-SRX missiles",
        "debris1"      : "Debris part",
        "debris2"      : "Debris part",
        "debris3"      : "Debris part",
        "debris4"      : "Debris part",
        "debris5"      : "Debris part",
        "debris6"      : "Debris part",
        "debris7"      : "Debris part",
        "document"     : "A document for the<br />Syntrogenic Accelerator",
        "karbonite01"  : "Karbonite tablet #1",
        "karbonite02"  : "Karbonite tablet #2",
        "karbonite03"  : "Karbonite tablet #3",
        "karbonite04"  : "Karbonite tablet #4",
        "karbonite05"  : "Karbonite tablet #5",
        "karbonite06"  : "Karbonite tablet #6",
        "karbonite07"  : "Karbonite tablet #7",
        "karbonite08"  : "Karbonite tablet #8",
        "karbonite09"  : "Karbonite tablet #9",
        "karbonite10"  : "Karbonite tablet #10",
        "karbonite11"  : "Karbonite tablet #11",
        "karbonite12"  : "Karbonite tablet #12",
        "license-a"    : "Drilling License Alpha",
        "license-b"    : "Drilling License Beta",
        "license-c"    : "Drilling License Gamma",
        "locked"       : "Locked house",
        "map"          : "Part of the PID-map",
        "medallion1"   : "Part of the<br />Zonkerian Medallion",
        "medallion2"   : "Part of the<br />Zonkerian Medallion",
        "medallion3"   : "Part of the<br />Zonkerian Medallion",
        "mission"      : '<span style="color: #00FF00;">ESCorp</span> / <span style="color: #FF0000;">FURI</span> mission',
        "ox-delta"     : "Drilling Ball OX-Delta",
        "ox-soldier"   : "Drilling Ball OX-Soldier",
        "pink"         : "Pink crystal in the house",
        "probe1"       : "Lycans rock probe<br />for AR-57 missiles",
        "probe2"       : "Spignysos rock probe<br />for AR-57 missiles",
        "retrofuser"   : "Lithium Retrofuser",
        "star_blue"    : "Blue Star",
        "star_green"   : "Green Star",
        "star_yellow"  : "Yellow Star",
        "star_turkey"  : "Turquoise Star",
        "star_orange"  : "Orange Star",
        "star_red"     : "Red Star",
        "star_violett" : "Violett Star",
        "spacesuit"    : "Spacesuit",
        "surf_engine1" : "External Armor",
        "surf_engine2" : "Atmospheric Shield",
        "surf_engine3" : "Hydraulic Stabilisator",
        "surf_engine4" : "Engine Wreck",
        "transport"    : "Transport Mission"
    }

}


function buildTable() {
    end_x = map_size;
    start_x = end_x * -1;
    output = '<table border="0" cellspacing="0" cellpadding="0">\r\n';
    for (y = start_x; y <= end_x; y ++) {
        output += '<tr>';
        for (x = start_x; x <= end_x; x ++) {
            cell_id = "id[" + x + "][" + y + "]";
            output += '<td class="map_cell" id="' + cell_id + '"></td>';
        }
        output += '</tr>\r\n';
    }
    output += '</table>\r\n';
    document.getElementById('level_data').innerHTML = output;

    for (y = start_x; y <= end_x; y ++) {
        for (x = start_x; x <= end_x; x ++) {
            cell_id = "id[" + x + "][" + y + "]";
            elem = document.getElementById(cell_id);
            elem.onmousemove = eventHandler;
            elem.onmouseout = eventHandler;
            elem.onmouseover = eventHandler;
            elem.onclick = eventHandler;
            elem.style.cursor = 'pointer';
        }
    }

}


function eventHandler(E) {
    if (IE) {
       E = event;
       elem = E.srcElement;
    } else {
       elem = E.target;
    }
    info_box = document.getElementById('infobox');
//    old_mouse_x = mouse_x;
//    old_mouse_y = mouse_y;
    mouse_x = pos_x + Math.floor(elem.id.replace(/id\[(-*\d*)\]\[-*\d*\]/, "$1"));
    mouse_y = pos_y + Math.floor(elem.id.replace(/id\[-*\d*\]\[(-*\d*)\]/, "$1"));

    offsets = _getOffset(elem);

    if (IE) {
        x_offset = E.offsetX + offsets['left'];
        y_offset = E.offsetY + offsets['top'];
    } else {
        x_offset = E.pageX;
        y_offset = E.pageY;
    }
    
    info_box.style.top = (y_offset + 20) + "px";
    info_box.style.left = (x_offset + 20) + "px";
//    if (E.type == "mousemove" || E.type == "mouseover") {
    if (E.type == "mouseover") {
        if (!locked) {
            getInfo();
        } else {
            info_box.innerHTML = "[" + mouse_x + "][" + mouse_y + "]";
        }
        info_box.style.display = 'block';
    } else if (E.type == "mouseout") {
        info_box.style.display = 'none';
    }
    if (E.type == "click") {
        doc_title = document.getElementsByTagName("title")[0].text;
        doc_title = doc_title.replace(/\[-*\d*\]\[-*\d*\]/, "");
        doc_title = doc_title + "[" + mouse_x + "][" + mouse_y + "]";
        document.getElementsByTagName("title")[0].text = doc_title;
        pos_x = mouse_x;
        pos_y = mouse_y;
        loadMap();
    }
}


function opacHandler(E) {
    if (IE) {
       E = event;
       elem = E.srcElement;
    } else {
       elem = E.target;
    }
    offsets = _getOffset(elem);
    
    x_offset = ((IE) ? E.clientX - 7 : E.pageX - 5) - offsets['left'];
    y_offset = ((IE) ? E.clientY - 7 : E.pageY - 5) - offsets['top'];
    pointer = document.getElementById("opacity2");

    if (x_offset < 0) { x_offset = 0; }
    if (x_offset > 200) { x_offset = 200; }
    if (E.type == "click" || (E.type == "mousemove" && pointerDrag == true)) {
        pointer.style.left = x_offset + "px";
        opacity = 100 - Math.round(x_offset / 2);
        setOpacity();
    } else if (E.type == "mouseup" || E.type == "mouseout") {
        pointerDrag = false;
    } else if (E.type == "mousedown" && pointerDrag == false) {
        pointerDrag = true;
    }
}


function setOpacity() {
        elem = document.getElementById('level_data')
        elem.style.filter = 'alpha(opacity=' + opacity + ')'; 
        elem.style.MozOpacity = (opacity / 100);
        elem.style.opacity = (opacity / 100);
        document.getElementById('op_display').innerHTML = (100 - opacity) + "%";
        document.cookie = 'abmap_opacity=' + opacity + '; expires=' + expires;
}


function loadMap() {
    pos_x = Math.round(pos_x);
    pos_y = Math.round(pos_y);
    document.cookie = 'abmap_pos_x=' + pos_x + '; expires=' + expires;
    document.cookie = 'abmap_pos_y=' + pos_y + '; expires=' + expires;
    document.cookie = 'abmap_size=' + map_size + '; expires=' + expires;
    xmlHTTP_ABMapData.URL = '/map2.php?layer=js&x=' + pos_x + '&y=' + pos_y + '&size=' + map_size;
    if (!locked) {
        xmlHTTP_Send(xmlHTTP_ABMapData, 'GET', 'loadData', '');
    }
    document.getElementById('map_data').style.backgroundImage = 'url(./map.php?x=' + pos_x + '&y=' + pos_y + '&size=' + map_size + ')';
    document.getElementById('level_data').style.backgroundImage = 'url(./map2.php?x=' + pos_x + '&y=' + pos_y + '&size=' + map_size + '&layer=' + map_layer + '&name=' + map_name + ')';
//    document.getElementById('position_x').value = pos_x;
 //   document.getElementById('position_y').value = pos_y;
}


function loadData(textData, xmlData) {
    eval("mapdata =" + textData);
//xmlHTTP_ABMapData.MessageElem.innerHTML = textData;
}

function getInfo() {
    array_pos_x = mouse_x - pos_x + map_size;
    array_pos_y = mouse_y - pos_y + map_size;
    info_box = document.getElementById('infobox');
    planet_name = "";
    if (mapdata[array_pos_y][array_pos_x] == "") {
        img_data = '';
        box_data = '<br />[' + mouse_x + '][' + mouse_y + '] - No data for this level !';
    } else {
        mineral_data = '';
        merchant_data = '';
        img_data = '';
        if (mapdata[array_pos_y][array_pos_x].space) {
            level = mapdata[array_pos_y][array_pos_x].space;
            img_data = '<img src="./mapdata/[' + mouse_x + '][' + mouse_y + '].png" height="360" width="400" border="0" alt="" />';
            mineral_data = '<br /><table border="0" cellspacing="0" cellpadding="1" width="130">\r\n' +
                           ((level.green > 0) ? '    <tr><td align="right">' + level.green + 'x</td><td><img src="/images/abmap/gui/m_green.gif" border="0" alt="" /></td><td>=</td><td align="right">' + level.green + ' <img src="/images/abmap/gui/minerals.gif" border="0" alt="" /></td></tr>\r\n' : '') +
                           ((level.blue > 0) ? '    <tr><td align="right">' + level.blue + 'x</td><td><img src="/images/abmap/gui/m_blue.gif" border="0" alt="" /></td><td>=</td><td align="right">' + (level.blue * 5) + ' <img src="/images/abmap/gui/minerals.gif" border="0" alt="" /></td></tr>\r\n' : '') +
                           ((level.pink > 0) ? '    <tr><td align="right">' + level.pink + 'x</td><td><img src="/images/abmap/gui/m_purple.gif" border="0" alt="" /></td><td>=</td><td align="right">' + (level.pink * 25) + ' <img src="/images/abmap/gui/minerals.gif" border="0" alt="" /></td></tr>\r\n' : '') +
                           ((level.green > 0 || level.blue > 0 || level.pink > 0) ? '    <tr><td colspan="4"><hr /></td></tr>' : '') +
                           '<tr><td colspan="3"></td><td align="right">' + (Math.round(level.green) + Math.round(level.blue) * 5 + Math.round(level.pink * 25)) + ' <img src="/images/abmap/gui/minerals.gif" border="0" alt="" /></td></tr>\r\n' +
                           ((level.missile > 0) ? '    <tr><td align="right">' + level.missile + 'x</td><td><img src="/images/abmap/gui/m_missile.gif" border="0" alt="" /></td><td></td><td></td></tr>\r\n' : '') +
                           ((level.medic > 0) ? '    <tr><td align="right">' + level.medic + 'x</td><td><img src="/images/abmap/gui/m_medic.gif" border="0" alt="" /></td><td></td><td></td></tr>\r\n' : '') +
                           '</table><br />by \r\n' + level.name;
        }
        if (mapdata[array_pos_y][array_pos_x].merchant) {
            merchant_data = '<table border="0" cellspacing="0" cellpadding="1" width="100%">\r\n';
            if (mapdata[array_pos_y][array_pos_x].obj_pl) {
                 merchant_data += '<tr>' +
                                  '<td align="center" colspan="2" class="legend3"><img src="/images/abmap/objects/merchant_surface.png" border="0" alt="" /> Surface Merchant</td>' +
                                  '</tr>\r\n';
            } else {
                 merchant_data += '<tr>' +
                                  '<td align="center" colspan="2" class="legend3"><img src="/images/abmap/objects/merchant.png" border="0" alt="" /> Space Merchant</td>' +
                                  '</tr>\r\n';
            }
            merchant_data += '<tr>' +
                             '<td align="center" colspan="2">&nbsp;</td>' +
                             '</tr>\r\n';
            count = mapdata[array_pos_y][array_pos_x].merchant.length;
            for (i = 0; i < count; i ++ ) {
                 item = mapdata[array_pos_y][array_pos_x].merchant[i];
                 item_name = merch_trans[item.replace(/=\d*/, "")];
                 item_cost = '&nbsp;<img src="./images/abmap/gui/minerals.gif" border="0" alt="" /> ' + item.replace(/.+=/, "");
                 merchant_data += '<tr>' +
                                  '<td align="right">' + item_name + '</td>' +
                                  '<td align="left">' + item_cost + '</td>' +
                                  '</tr>\r\n';
            }
            merchant_data += '</table>\r\n';            
        }
        planet_name = (mapdata[array_pos_y][array_pos_x].name) ? " - " + mapdata[array_pos_y][array_pos_x].name : "";

        if (mapdata[array_pos_y][array_pos_x].surf_min) {
            surf_min_data = '<br />' + 
                            '<img src="/images/abmap/gui/surface.gif" border="0" alt="" />\r\n' +
                            '&nbsp;&nbsp;&nbsp;Surface: ' +
                            mapdata[array_pos_y][array_pos_x].surf_min;
            if (mapdata[array_pos_y][array_pos_x].surf_min2) {
                surf_min_data = surf_min_data + '&nbsp;/&nbsp;' + mapdata[array_pos_y][array_pos_x].surf_min2;
            }
            surf_min_data = surf_min_data + '&nbsp;<img src="./images/abmap/gui/minerals.gif" border="0" alt="" />';
        } else {
            surf_min_data = '';
        }
        if (mapdata[array_pos_y][array_pos_x].obj_sp) {
            desc = mapdata[array_pos_y][array_pos_x].obj_sp;
            if (desc != 'merchant' && desc != 'map' && desc != "missile" && desc != "wormhole") {
                desc2 = obj_trans[desc];
                merchant_data +=  '<br /><img src="./images/abmap/objects/' + desc + '.png" border="0" alt="" /> <span class="legend3">' + desc2 + '</span>';
                if (mapdata[array_pos_y][array_pos_x].obj_sp2) {
                    merchant_data +=  '<br /><br />' + mapdata[array_pos_y][array_pos_x].obj_sp2;
                }
            } else if (desc == "missile") {
                desc2 = mapdata[array_pos_y][array_pos_x].obj_sp2;
                merchant_data +=  '<img src="./images/abmap/objects/' + desc + '.png" border="0" alt="" /> <span class="legend3">Missile #' + desc2 + '</span>';
            } else if (desc == "wormhole") {
                desc2 = mapdata[array_pos_y][array_pos_x].obj_sp2;
                merchant_data +=  '<img src="./images/abmap/objects/' + desc + '.png" border="0" alt="" /> <span class="legend3">Wormhole</span><br /><br />This wormhole leads to ' + desc2;
            }
        }
        
        if (mapdata[array_pos_y][array_pos_x].obj_pl) {
            desc = mapdata[array_pos_y][array_pos_x].obj_pl;
            if (desc != "merchant") {
                desc2 = obj_trans[desc];
                merchant_data += '<br /><br /><img src="/images/abmap/gui/' + desc + '.gif" border="0" alt="" /> <span class="legend3">' + desc2 + '</span>';
            }
            if (desc == "transport") {
                trans_data = mapdata[array_pos_y][array_pos_x].pl_data.split(",");
                merchant_data += '<br /><br />Transport this alien to <span class="destination">' + trans_data[0] + '</span>';
                trans_fee = '';
                if (trans_data[1] == "0" && trans_data[2] == "0") {
                    trans_fee = '<span style="color: #FF0000"><b>nothing !</b></span>';
                }
                if (trans_data[1] != "0") {
                    trans_fee = ' <span class="trans_fee">' + trans_data[1] + '</span> <img src="/images/abmap/gui/minerals2.gif" border="0" alt="" />';
                }
                if (trans_data[1] != "0" && trans_data[2] != "0") {
                    trans_fee += ' and ';
                }
                if (trans_data[2] != "0") {
                    trans_fee += ' <span class="trans_fee">' + trans_data[2] + '</span> <img src="/images/abmap/gui/shc.gif" border="0" alt="" />';
                }
                merchant_data += '<br />He offers ' + trans_fee;
            }
            if (desc == "map") {
                map_data = mapdata[array_pos_y][array_pos_x].pl_data.split(",");
                merchant_data += '<br /><br />This is part \'<span class="destination">' + map_data[0] + '</span>\''
                               + '<br />It costs <span class="trans_fee">' + map_data[1] + '</span> <img src="/images/abmap/gui/minerals2.gif" border="0" alt="" />';
            }
            if (desc == "blue" || desc == "pink") {
                minerals = mapdata[array_pos_y][array_pos_x].pl_data
                merchant_data += '<br /><br />If collected, you will gain <span class="trans_fee">' + minerals + '</span> <img src="/images/abmap/gui/minerals2.gif" border="0" alt="" />';
            }
            if (desc == "mission") {
                merchant_data += '<br /><br /> <span style="color: #00FF00;"><b>ESCorp</b></span>: Will earn <span class="trans_fee">5</span> <img src="/images/abmap/gui/shc.gif" border="0" alt="" />';
                mission_data = mapdata[array_pos_y][array_pos_x].pl_data.split(",");
                mission_fee = '';
                if (mission_data[0] == "0" && mission_data[1] == "0") {
                    mission_fee = '<span style="color: #FF0000"><b>nothing !</b></span>';
                }
                if (mission_data[0] != "0") {
                    mission_fee = ' <span class="trans_fee">' + mission_data[0] + '</span> <img src="/images/abmap/gui/minerals2.gif" border="0" alt="" />';
                }
                if (mission_data[0] != "0" && mission_data[1] != "0") {
                    mission_fee += ' and ';
                }
                if (mission_data[1] != "0") {
                    mission_fee += ' <span class="trans_fee">' + mission_data[1] + '</span> <img src="/images/abmap/gui/shc.gif" border="0" alt="" />';
                }
                merchant_data += '<br /> <span style="color: #FF0000;"><b>FURI</b></span>: Will earn ' + mission_fee;
            }
        }

        box_data = '<table border="0" cellspacing="0" cellpadding="3" width="100%">\r\n' +
                   '<tr>\r\n' +
                   '<td width="170" align="center" valign="top">\r\n' +
                   mineral_data +
                   '</td>\r\n' +
                   '<td rowspan="2" valign="top">\r\n' +
                   merchant_data +
                   '</td>\r\n' +
                   '</tr>\r\n' +
                   '<tr>\r\n' +
                   '<td align="center" valign="top">\r\n' +
                   surf_min_data + 
                   '</td>\r\n' +
                   '</tr>\r\n' +
                   '</table>\r\n';
    }
    info_box.innerHTML = "[" + mouse_x + "][" + mouse_y + "]" + planet_name;
    document.getElementById('pic_box').innerHTML = img_data;
    xmlHTTP_ABMapData.MessageElem.innerHTML = box_data;
}

function changeSize(mode) {
 /*   if (mode == 0) {
        map_size = document.getElementById('map_size').value;
    } else if (mode == -1) {
        map_size --;
        document.getElementById('map_size').value = map_size;
    } else if (mode == 1) {
        map_size ++;
        document.getElementById('map_size').value = map_size;
    } else if (mode == 2) {
        document.getElementById('map_size').value = map_size;
    }
    if (map_size > 20) { map_size = document.getElementById('map_size').value = 20; }
    if (map_size < 5) {  map_size = document.getElementById('map_size').value = 5; } */
    document.getElementById('map_data').style.width =
    document.getElementById('level_data').style.width = ((map_size * 2 + 1) * 20) + "px";
    document.getElementById('map_data').style.height =
    document.getElementById('level_data').style.height = ((map_size * 2 + 1) * 18) + "px";
    buildTable();
    loadMap();
}


function close_welcome() {
    elem = document.getElementById("welcome");
    elem.style.display = 'none';
    document.cookie = 'abmap_welcome=1; expires=' + expires2;
}


function changeLayer(mode) {
    if (mode == 1 && map_layer == "pl") {
        map_layer = "sp";
        loadMap();
    } else if (mode == 2 && map_layer == "sp") {
        map_layer = "pl";
        loadMap();
    }
}


function _getOffset(elem) {
    var oLeft = elem.offsetLeft;
    var oTop = elem.offsetTop;

    while ((elem = elem.offsetParent) != null) {
        oLeft += elem.offsetLeft;
        oTop += elem.offsetTop;
    }
    return { 'left' : oLeft, 'top' : oTop };
}



}
/*
     FILE ARCHIVED ON 02:51:30 May 06, 2012 AND RETRIEVED FROM THE
     INTERNET ARCHIVE ON 17:13:44 Aug 24, 2024.
     JAVASCRIPT APPENDED BY WAYBACK MACHINE, COPYRIGHT INTERNET ARCHIVE.

     ALL OTHER CONTENT MAY ALSO BE PROTECTED BY COPYRIGHT (17 U.S.C.
     SECTION 108(a)(3)).
*/
/*
playback timings (ms):
  captures_list: 0.55
  exclusion.robots: 0.022
  exclusion.robots.policy: 0.01
  esindex: 0.009
  cdx.remote: 22.902
  LoadShardBlock: 1026.895 (3)
  PetaboxLoader3.datanode: 48.453 (4)
  PetaboxLoader3.resolve: 1420.319 (3)
  load_resource: 471.283
*/