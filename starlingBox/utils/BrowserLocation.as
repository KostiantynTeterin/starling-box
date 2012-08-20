package starlingBox.utils
{
	import flash.external.ExternalInterface;
	
	import starlingBox.utils.URLUtil;
	
	/**
	 * http://code.google.com/p/developmentarc-core/wiki/BrowserLocationUtil
	 * 
	 * Class is a utility class that provides a mix of functionaltity from Flex's BrowserManager and URL classes.  
	 * The goal of the class is to give an application a mechinism to query the browser's current url (like one can with BrowserManager),
	 * but without leveraging the history managment system that flex provides. This allows application that do not include history.js a 
	 * way to retreive the current runtime url and parse all the various parts pieces. Below is a breakdown of a typical url and all
	 * the properties one can access.
	 * <br />
	 * <listing version="3.0">
	 *    https://google.com:8080/path/is/here/?param1=value1#page2
	 *    \___/   \________/ \__/\____________/ \___________/ \__/
	 *      |        |        |       |               |        |
     *   |   server name  port    path           query   fragment    
	 *   protocal 
	 * </listing>              
	 */
	public class BrowserLocation
	{
		
		/**
		 * @private 
		 */
		protected static var _testURL:String;
		
		/**
		 * Method returns the current full url in the application.
		 * The functionality of this method relies on ExternalInterface to call
		 * 'window.location.href.toString' to gather the current url.
		 * 
		 * @return String of the current url.
		 */
		public static function get url():String {
			
			if(_testURL) {
				return _testURL;
			}
			else {
				return ExternalInterface.call('window.location.href.toString');
			}
			
		}
		
		/*
		 * ajout christophe 
		 * */
		public static function set url(url:String):void {
			_testURL = url;			
		}
		
		/**
		 * Method encapsulates the URL's getProtocal method returning the protocal of the current url.
		 * <br/>
		 * Example: http://google.com:8080/path/is/here/?param1=value1#page2 returns  http
		 * 
		 * @return String Current protocal used on the current url.
		 */
		public static function get protocal():String {
			return URLUtil.getProtocol(BrowserLocation.url);
		}
		
		/**
		 * Method returns the server name in the current url of the application.
		 * <br/>
		 * Example: http://google.com:8080/path/is/here/?param1=value1#page2 returns google.com
		 * 
		 * @return String Current server name in url.
		 */ 
		public static function get serverName():String {
			return URLUtil.getServerName(BrowserLocation.url);
		}
		
		/**
		 * Method returns the port number specificed in the current url. If no port is provided 0 will be returned.
		 * This method utilizes the Flex URL.getPort() method. See that method for more details.
		 * <br/>
		 * Example: http://google.com:8080/path/is/here/?param1=value1#page2 returns 8080
		 * 
		 * @return String Current port used in the url.
		 */
		public static function get port():uint {
			return URLUtil.getPort(BrowserLocation.url);
		}
		
		/**
		 * Method returns the path portion of the current url
		 *<br/>
		 * Example: http://google.com:8080/path/is/here/?param1=value1#page2 returns /path/is/here/
		 * 
		 * @return String Path in the current url.
		 */
		public static function get path():String {
			var url:String = BrowserLocation.url;
			var serverName:String = URLUtil.getServerNameWithPort(url);
			var firstIndex:int = url.indexOf(serverName, 0) + serverName.length;
			
			var lastIndex:int;
			
			// Split on ?
			lastIndex = url.indexOf("?");
			
			// No ? - Split on #
			if(lastIndex == -1) {
				lastIndex = url.indexOf("#");
			} 
			// No ? or # use end of url
			if(lastIndex == -1) {
				lastIndex = url.length;
			}			
			
			return url.slice(firstIndex, lastIndex);
		}
		/**
		 * Method return the current query string of the url, which is the protion of the url
		 * after the servername and/or port and before the framgment of the url.
		 * <br/>
		 * Example: http://google.com:8080/path/is/here/?param1=value1#page2 returns param1=value1
		 * 
		 * @return query String of the query portion of the current url in the system.
		 */
		public static function get query():String {
			var parts:Array = BrowserLocation.url.split("?");
			
			if(parts.length == 2) {
				return parts[1].split("#")[0];
			}
			else {
				return "";
			}
		}
		
		/**
		 * Method breaks down the query string of the current url
		 * passing back a generic object with each key/value pair.
		 * <br/>
		 * Example: http://google.com:8080/path/is/here/?param1=value1#page2 returns {param1:'value1'}
		 * <br />
		 * <b>Note:</b>  This method utilizes the mx.utils.URL.stringToObject() method, which 
		 * overrides parameters of the same name with the last value found in the string.
		 * <br />
		 * Example: Example: http://google.com:8080/path/is/here/?param1=value1&param1=value2#page2 returns {param1:'value2'} 
		 * 
		 * @return Object Generic object containing each key/value pair found in the current urls query.
		 */
		public static function get parameters():Object {
			var query:String = BrowserLocation.query;
			
				if(query.length > 0) {
					var parameters:String = query.split("#")[0];
					return URLUtil.stringToObject(parameters,"&");	
					//return mx.utils.URL.stringToObject(parameters,"&");	
				}
				else {
					return new Object();
				}
		}
		
		/**
		 * Method returns the fragment portion of the url which is all data after the "#".
		 * <br/>
		 * Example: http://google.com:8080/path/is/here/?param1=value1#page2 returns page2
		 * 
		 * @return String Current fragment in the current url.
		 */
		public static function get fragment():String {
			var parts:Array = BrowserLocation.url.split("#");
			
			if(parts.length == 2) {
				return parts[1];
			}
			else {
				return "";
			}
		}
	}
}