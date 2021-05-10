// const SERVER_NAME = "http://192.168.1.152:8000";
// // const SERVER_NAME = "http://3.17.145.13/"; // production ip address

// const SERVER_NAME = "192.168.1.225:8000";
const SERVER_NAME = "3.17.145.13"; // production ip address

// PUBLIC URL
var getRequestServerName = SERVER_NAME;
var postRequestServerName = 'http://' + SERVER_NAME;

const kGoogleApiKey = "AIzaSyAQSCSiJMsoMca0n65p0vPv5Em8Uk8FjLQ";
var registerUserUri = "$postRequestServerName/register/";
var userLoginUri = "$postRequestServerName/user-login/";
var userDataUri = "/user-data/";
var updateWhatsappNumberUri = "$postRequestServerName/update-whatsapp-number/";
var updateWindowshopperProfileUri =
    "$postRequestServerName/update-windowshopper-profile/";
var businessAccountSwitchUri =
    "$postRequestServerName/business-account-switch/";
var updateVendorProfileUri = "$postRequestServerName/update-vendor-profile/";
var changePasswordUri = "$postRequestServerName/change-password/";
var userPostUri = '/post/user-post/';
var userCreatePostUri = "$postRequestServerName/post/create-post/";
var userSinglePostDataUri = "/post/post-data/";
var searchAccountPostUri = "/post/search-post/";
var searchAccountUri = "/account/search-account/";
var updatePostUri = "$postRequestServerName/post/update-post/";
var accountInfoUri = "/account/";
var accountPostUri = "/post/account/";
var allPostUri = "/post/post-list/";
var updateProfilePictureUri =
    "$postRequestServerName/account/update-profile-picture/";
var removeProfilePictureUri =
    "$postRequestServerName/account/remove-profile-picture/";

const FETCH_POST_URI =
    "$SERVER_NAME/post/post-list/"; // will be removed in the future

const ALL_COUNTRY_URI =
    "$SERVER_NAME/master_data/country/"; // will be removed in the future

// const TOP30_CATEGORY_URI =
//     "$SERVER_NAME/master_data/top30category/"; // will be removed in the future
// const ALL_CATEGORY_URI =
//     "$SERVER_NAME/master_data/allCategory/"; // will be removed in the future
// const VALIDATE_USERNAME_URI = "$SERVER_NAME/validate/";
// const UPDATE_PROFILE_URI = "$SERVER_NAME/update/";
