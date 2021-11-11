<%@page import="common.properties.PropertiesUtil"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page contentType="text/html;charset=euc-kr"  
%>
<%
	request.setCharacterEncoding("UTF-8");

	JSONObject resultJson = new JSONObject();
	
	Integer errorCode = 10039;
	String errorMsg  = "결제 취소.";
	String resultUrl = PropertiesUtil.getInstance().getString("pay.resultUrl");
	
	resultJson.put("resultCode", errorCode);
	resultJson.put("resultMsg", errorMsg);
	
	session.setAttribute("resultJson", resultJson);
	
	// go to result
    String html = "<script>var myloc = location.href; var resloc = myloc.substring(0, myloc.lastIndexOf('/')) + '/' + '" + resultUrl + "'; window.location.href = resloc;</script>";
	out.println(html);
%>
<!-- <script type="text/javascript">
	function getLocalUrl(mypage) 
		{ 
			var myloc = location.href; 
			return myloc.substring(0, myloc.lastIndexOf('/')) + '/' + mypage;
		}
</script> -->