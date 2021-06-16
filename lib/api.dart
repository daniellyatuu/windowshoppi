const SERVER_NAME = "192.168.1.106:8000";
// const SERVER_NAME = "3.17.145.13"; // production ip address

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
var authSearchAccountPostUri = "/post/auth-search-post/";
var searchAccountUri = "/account/search-account/";
var updatePostUri = "$postRequestServerName/post/update-post/";
var accountInfoUri = "/account/";
var followerFollowingPostNumberUri = "/account/follower-number/";
var accountPostUri = "/post/account/";
var allPostUri = "/post/post-list/";
var authAllPostUri = "/post/auth-post-list/";
var followingPostUri = "/post/following-account-post-list/";
var updateProfilePictureUri =
    "$postRequestServerName/account/update-profile-picture/";
var removeProfilePictureUri =
    "$postRequestServerName/account/remove-profile-picture/";
var followUnfollowAccountUri =
    '$postRequestServerName/account/follow-unfollow/';
var accountListUri = '/account/account-list';
var updateFcmTokenUri = '$postRequestServerName/update-fcm-token/';
var notificationUri = '/notification/user-notification/';

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
