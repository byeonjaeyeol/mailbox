<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@page import="common.properties.PropertiesUtil"%>
<%@page import="orchestrator.orchestrator"%>
<%@ page contentType="text/html;charset=euc-kr" %>
<%
	Logger logger = orchestrator.paylog;
	
	request.setCharacterEncoding("UTF-8");
	
	JSONObject resultJson = (JSONObject)session.getAttribute("resultJson");
	JsonObject sessionData = new Gson().fromJson(session.getAttribute("userParam").toString(), JsonObject.class);
	//-----------------------------------------------------------------------
	// set data for log
	String errCode = resultJson.get("resultCode").toString();
	String errMsg  = resultJson.get("resultMsg").toString();
	String trno = "";
	Integer pcode_idx = 0;
	if ( resultJson.get("trno") != null && !resultJson.get("trno").equals("") ) {
		trno = resultJson.get("trno").toString();
	}
	
	if ( sessionData.get("pcode_idx") != null && !sessionData.get("pcode_idx").getAsString().equals("")){
		pcode_idx = sessionData.get("pcode_idx").getAsInt();
	}
	
	/*=================================================================================================
	* ��� �α� ���
	===================================================================================================
	*/
	// ���� �����丮 ���� ���� �� �α� ó��.
	if (resultJson.get("dbError") != null) {	
		String dbErrMsg = resultJson.get("dbError").toString();
		String msg = "[DB ���� ����] pcode_idx : " + pcode_idx + ", �ŷ���ȣ : " + trno + ", DBmsg : " + dbErrMsg;
		
		logger.info(msg);
	
	} 
	
	if ( errCode.equals("200") ) {	// ���� ����
		logger.info("[���� ����]  pcode_idx : " + pcode_idx + ", �ŷ���ȣ : " + trno + ", code : " + errCode + ", msg : " + errMsg );
		
	} else {	// ���� ����
		logger.info("[���� ����]  pcode_idx : " + pcode_idx + ", �ŷ���ȣ : " + trno + ", code : " + errCode + ", msg : " + errMsg );
		
	}
	
	/*=================================================================================================
	* resultCode 
	10031 : pcodeidx / ci not matched.
	10032 : There is no payment data. check params.
	10033 : pay amount not matched. check params.
	10034 : pcodeidx / payidx / ci params cannot be null.
	10035 : parseException / SQLException
	10036 : ���� ����.
	10037 : ����Ÿ�Ӿƿ��ŷ�.
	10038 : KSPAY module error.
	10039 : ���� ���.
	200 : SUCCESS
	===================================================================================================
	*/
	
	session.invalidate();
%>
<html>
<head> 
	<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" >
<script type="text/javascript">
	var res = '<%=resultJson %>';
	Result.postMessage(res);
</script>
</head>
<body bgcolor=#ffffff onload="">
<%-- <h1>result.jsp ������ �Դϴ�.</h1>
<%=resultJson %> --%>
</body>
</html>