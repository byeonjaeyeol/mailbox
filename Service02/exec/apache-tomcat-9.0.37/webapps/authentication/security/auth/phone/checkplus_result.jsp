<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="orchestrator.orchestrator"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%
	Logger logger = orchestrator.authlog;
	
	JSONObject resultJson = new JSONObject();
	
	if( session.getAttribute("resultJson") != null ) {
		resultJson = (JSONObject)session.getAttribute("resultJson");
		logger.info("resultJson : " + resultJson);
		
	} else {
		String msg = "[본인 인증 실패. 서버 에러.] error message : There's no result Json. Identify.";
		
		resultJson.put("resultCode", "101");
		resultJson.put("resultMsg", msg);
		
		logger.error(msg);
		
	}
	
	/*=================================================================================================
	* resultCode 
	- 200 : 본인인증 성공.
	- 101 : 서버 복호화 실패. 서버 에러. map data 없음.
	- 102 : 사용자 본인인증 실패. 사용자 에러. map data 있음.
	- 103 : 본인인증 성공 but.컨트롤러 에러. map data 있음.
	===================================================================================================
	*/
			
			
	session.invalidate();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<script type="text/javascript">
	var res = '<%=resultJson %>';
	Result.postMessage(res);
</script>
</head>
<body>
<%-- <h1>result.jsp 입니다.</h1><br>
<%=resultJson %> --%>
</body>
</html>