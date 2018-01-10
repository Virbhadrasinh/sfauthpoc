<%@ page import="canvas.SignedRequest" %>
<%@ page import="java.util.Map" %>
<%
    // Pull the signed request out of the request body and verify/decode it.
    Map<String, String[]> parameters = request.getParameterMap();
    String[] signedRequest = parameters.get("signed_request");
    String[] sfdcCanvasAuth = parameters.get("_sfdc_canvas_auth");
    String yourConsumerSecret = System.getenv("CANVAS_CONSUMER_SECRET");
    yourConsumerSecret = "6837139541783427873";
    String signedRequestJson = "";
    boolean isSignedRequest = false;
    //yourConsumerSecret="6837139541783427873";
    
    if (signedRequest != null) {
        signedRequestJson = SignedRequest.verifyAndDecodeAsJson(signedRequest[0], yourConsumerSecret);
        isSignedRequest = true; 
    } else if(sfdcCanvasAuth != null){
    	//received GET instead of signed post means that users must self authorize (org setting)
    	String[] loginUrl = parameters.get("loginUrl");

    	// New location to be redirected
        //String site = new String("/examples/hello-world/sfOauth.html?loginUrl="+loginUrl[0]);
        //response.setStatus(response.SC_MOVED_TEMPORARILY);
        //response.setHeader("Location", site); 
    	  
    	  
    } else {
    	%>This App must be invoked via a canvas app.<%    	
    }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>

    <title>Hello World Canvas App</title>
    <link rel="stylesheet" type="text/css" href="/sdk/css/canvas.css" />
    <link rel="stylesheet" href="/examples/hello-world/app.css" />
    <script type="text/javascript" src="/sdk/js/canvas-all.js"></script>
    <script type="text/javascript" src="/scripts/json2.js"></script>

	<script>
		function getParameterByName(name, url) {
		    if (!url) url = window.location.href;
		    name = name.replace(/[\[\]]/g, "\\$&");
		    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
		        results = regex.exec(url);
		    if (!results) return null;
		    if (!results[2]) return '';
		    return decodeURIComponent(results[2].replace(/\+/g, " "));
		}
	
		function logout() {
			Sfdc.canvas.oauth.logout();
		}
		
		function authorize() {
			var loginUrl = getParameterByName("loginUrl");

			//if we don't get login.salesforce, then we're in a sandbox.
			if(loginUrl.indexOf('login.salesforce.com')!==-1) {
				loginUrl = "https://login.salesforce.com/services/oauth2/authorize";
			} else {
				loginUrl = "https://test.salesforce.com/services/oauth2/authorize";
			}
			//begin login/authorize process
			Sfdc.canvas.oauth.login(
				{uri : loginUrl,
					params: {
						response_type : "code",
						scope : "id full",
						client_id : "3MVG9ZL0ppGP5UrD3E2l0ZOtoL_07_YlrJ3Y26p2C1dFyafzQ4o3.VUqx7MO4Csp4QLw1b2ZpRg_IPYsW0zAb",
						redirect_uri : encodeURIComponent("https://sfdcoauthpoc.herokuapp.com/sdk/callback.html")
				}});
		}
		
		function refreshApp() {
			Sfdc.canvas.client.repost({refresh : true});
		}
	</script>    
</head>
<body>
    <div id="auth-container" style="display: none;">
	    <div id="oauth">
			<h2 class="sub-title">User Authentication Required</h2>
		</div>
	
		<div class="button-wrapper oauth">
	  		<button id="login" class="btn btn-default">authorize app</button>
		</div>
    </div>
    
    <div id="usename-container" style="display: none;">
	<span id='username'></span>
    </div>
    
    <script>
        Sfdc.canvas(function() {
        	if(!<%=isSignedRequest%>) {
        		var loggedIn = Sfdc.canvas.oauth.loggedin();
    	    	if (loggedIn) {
    	      		Sfdc.canvas.client.repost({refresh : true});
    	    	}
    	    	document.getElementById("login").addEventListener("click", function(){
    	    		logout();
    	    		authorize();
    	    	});
    	    	document.getElementById('auth-container').style.display = 'block';
        	} else {
        		
        		
        		var sr = JSON.parse('<%=signedRequestJson%>');
                // Save the token
		    
		    console.log("sr---->",sr);
                

                Sfdc.canvas.oauth.token(sr.oauthToken);
                Sfdc.canvas.byId('username').innerHTML = JSON.stringify(sr.context.environment.record);
                
                document.getElementById('usename-container').style.display = 'block';
        	}
        });
    </script>
</body>
</html>
