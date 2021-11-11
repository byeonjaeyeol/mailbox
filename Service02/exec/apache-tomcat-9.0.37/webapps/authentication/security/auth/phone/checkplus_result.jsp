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
		String msg = "[���� ���� ����. ���� ����.] error message : There's no result Json. Identify.";
		
		resultJson.put("resultCode", "101");
		resultJson.put("resultMsg", msg);
		
		logger.error(msg);
		
	}
	
	/*=================================================================================================
	* resultCode 
	- 200 : �������� ����.
	- 101 : ���� ��ȣȭ ����. ���� ����. map data ����.
	- 102 : ����� �������� ����. ����� ����. map data ����.
	- 103 : �������� ���� but.��Ʈ�ѷ� ����. map data ����.
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
<%-- <h1>result.jsp �Դϴ�.</h1><br>
<%=resultJson %> --%>
</body>
</html>