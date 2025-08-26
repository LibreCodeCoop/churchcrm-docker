<?php
/*******************************************************************************
 *
 *  filename    : Include/Config.php
 *  website     : https://churchcrm.io
 *  description : global configuration
 *
 ******************************************************************************/

// Database connection constants
$sSERVERNAME = getenv('MARIADB_HOST') ?: 'localhost';
$dbPort = '3306';
$sUSER = getenv('MARIADB_USER') ?: 'root';
$sPASSWORD = getenv('MARIADB_PASSWORD') ?: '';
$sDATABASE = getenv('MARIADB_DATABASE') ?: 'churchcrm';
$TwoFASecretKey = getenv('TFA_SECRET') ?: 'ChangeThisToASecureRandomStringBeforeUse';

// Root path of your ChurchCRM installation ( THIS MUST BE SET CORRECTLY! )
//
// Examples:
// - if you will be accessing from http://www.yourdomain.com/churchcrm then you would enter '/churchcrm' here.
// - if you will be accessing from http://www.yourdomain.com then you would enter '' ... an empty string for a top level installation.
//
// NOTE:
// - the path SHOULD Start with slash, if not ''.
// - the path SHOULD NOT end with slash.
// - the is case sensitive.
$sRootPath = getenv('ROOT_PATH') ?: '/index.php';

// Set $bLockURL=TRUE to enforce https access by specifying exactly
// which URL's your users may use to log into ChurchCRM.
$bLockURL = false;

// URL[0] is the URL that you prefer most users use when they
// log in.  These are case sensitive.
$URL[0] = getenv('BASE_URL') ?: 'http://localhost/';
// List as many other URL's as may be needed. Number them sequentially.
//$URL[1] = 'https://www.mychurch.org/churchcrm/';
//$URL[2] = 'https://www.mychurch.org:8080/churchcrm/';
//$URL[3] = 'https://www.mychurch.org/churchcrm/';
//$URL[4] = 'https://ssl.sharedsslserver.com/mychurch.org/churchcrm/';
//$URL[5] = 'https://crm.mychurch.org/';

// If you are using a non-standard port number be sure to include the
// port number in the URL. See example $URL[2]

// To enforce https access make sure that "https" is specified in all of the
// the allowable URLs.  Safe exceptions are when you are at the local machine
// and using "localhost" or "127.0.0.1"
$_SERVER['HTTPS'] = (getenv('IGNORE_HTTPS_CHECK') == 'true') ? 'on' : $_SERVER['HTTPS'];

if (getenv('INTERNAL_DOMAIN') && isset($_SERVER['HTTP_REFERER'])) {
    $_SERVER['HTTP_REFERER'] = (function() {
        $original_referer = $_SERVER['HTTP_REFERER'];
        $parsed_url = parse_url($original_referer);

        return $parsed_url['scheme'] . '://'
            . getenv('INTERNAL_DOMAIN')
            . (isset($parsed_url['path']) ? $parsed_url['path'] : '')
            . (isset($parsed_url['query']) ? '?' . $parsed_url['query'] : '');
    })();
}

// When using a shared SSL certificate provided by your webhost for https access
// you may need to add the shared SSL server name as well as your host name to
// the URL.  See example $URL[4]

// Sets which PHP errors are reported see http://php.net/manual/en/errorfunc.constants.php
error_reporting(E_ERROR);

//
// SETTINGS END HERE.  DO NOT MODIFY BELOW THIS LINE
//
// Absolute path must be specified since this file is called
// from scripts located in other directories
require_once dirname(__FILE__).DIRECTORY_SEPARATOR.'LoadConfigs.php';
