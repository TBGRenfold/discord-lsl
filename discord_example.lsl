key REQUEST_KEY;

string WEBHOOK_CHANNEL = "";
string WEBHOOK_TOKEN =  "";
string WEBHOOK_URL = "https://discordapp.com/api/webhooks/";
integer WEBHOOK_WAIT = TRUE;

string slurl(key AvatarID)
{
    string regionname = llGetRegionName();
    vector pos = llList2Vector(llGetObjectDetails(AvatarID, [ OBJECT_POS ]), 0);
 
    return "http://maps.secondlife.com/secondlife/"
        + llEscapeURL(regionname) + "/"
        + (string)llRound(pos.x) + "/"
        + (string)llRound(pos.y) + "/"
        + (string)llRound(pos.z) + "/";
}

key PostToDiscord(key AvatarID, string Message)
{
    list json = [ 
        "username", llGetObjectName() + "",
        "content", llGetUsername(AvatarID) + ": " + Message + "\n\nProfile: http://my.secondlife.com/" + llGetUsername(AvatarID) + "\nLocation: " + slurl(AvatarID),
        "avatar_url", "https://my-secondlife-agni.akamaized.net/users/" + llGetUsername(AvatarID) + "/sl_image.png"
	];
    string query_string = "";
    if (WEBHOOK_WAIT)
        query_string += "?wait=true";

    return llHTTPRequest(WEBHOOK_URL + WEBHOOK_CHANNEL + "/" + WEBHOOK_TOKEN + query_string, 
    [ 
        HTTP_METHOD, "POST", 
        HTTP_MIMETYPE, "application/json",
        HTTP_VERIFY_CERT,TRUE,
        HTTP_VERBOSE_THROTTLE, TRUE,
        HTTP_PRAGMA_NO_CACHE, TRUE ], llList2Json(JSON_OBJECT, json));
}

default
{
    state_entry()
    {

    }
    
    touch_start(integer total_number)
    {
        REQUEST_KEY = PostToDiscord(llDetectedKey(0), "Help point info from script :P");
    }
    http_response(key request_id, integer status, list metadata, string body)
    {
        if(REQUEST_KEY == request_id)
        {
            if (WEBHOOK_WAIT)
                llOwnerSay(body);   
        }
    }
}