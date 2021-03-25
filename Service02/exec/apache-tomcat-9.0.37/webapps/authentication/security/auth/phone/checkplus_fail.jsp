<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="orchestrator.orchestrator"%>
<%@page import="common.properties.PropertiesUtil"%>
<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%
	Logger logger = orchestrator.authlog;
	
	String resultUrl = PropertiesUtil.getInstance().getString("auth.resultUrl");
	
	/*=================================================================================================
	* NICE �������� ���� ó��
	===================================================================================================
	*/
    NiceID.Check.CPClient niceCheck = new  NiceID.Check.CPClient();
	
    java.util.HashMap mapresult = null;
    String msg = "";

    String sEncodeData = requestReplace(request.getParameter("EncodeData"), "encodeData");

    String sSiteCode = PropertiesUtil.getInstance().getString("auth.sSiteCode");		// NICE�κ��� �ο����� ����Ʈ �ڵ�
    String sSitePassword = PropertiesUtil.getInstance().getString("auth.sSitePassword");// NICE�κ��� �ο����� ����Ʈ �н�����

    String sCipherTime = "";			// ��ȣȭ�� �ð�
    String sRequestNumber = "";			// ��û ��ȣ
    String sErrorCode = "";				// ���� ����ڵ�
    String sAuthType = "";				// ���� ����
    String sMessage = "";
    String sPlainData = "";
    
    int iReturn = niceCheck.fnDecode(sSiteCode, sSitePassword, sEncodeData);

    if( iReturn == 0 )
    {
        sPlainData = niceCheck.getPlainData();
        sCipherTime = niceCheck.getCipherDateTime();
        
        // ����Ÿ�� �����մϴ�.
        mapresult = niceCheck.fnParse(sPlainData);
        
        sRequestNumber 	= (String)mapresult.get("REQ_SEQ");
        sErrorCode 		= (String)mapresult.get("ERR_CODE");
        sAuthType 		= (String)mapresult.get("AUTH_TYPE");
    }
    else if( iReturn == -1)
    {
        sMessage = "��ȣȭ �ý��� �����Դϴ�.";
    }    
    else if( iReturn == -4)
    {
        sMessage = "��ȣȭ ó�������Դϴ�.";
    }    
    else if( iReturn == -5)
    {
        sMessage = "��ȣȭ �ؽ� �����Դϴ�.";
    }    
    else if( iReturn == -6)
    {
        sMessage = "��ȣȭ ������ �����Դϴ�.";
    }    
    else if( iReturn == -9)
    {
        sMessage = "�Է� ������ �����Դϴ�.";
    }    
    else if( iReturn == -12)
    {
        sMessage = "����Ʈ �н����� �����Դϴ�.";
    }    
    else
    {
        sMessage = "�˼� ���� ���� �Դϴ�. iReturn : " + iReturn;
    }
    
    // set result info
    if ( sMessage.equals("") ) {
    	msg = "[���� ���� ����. ����� ����.] error code : " + sErrorCode + ", error message : " + sMessage;

    	session.setAttribute("resultCode", "102");	// ����� �������� ����. ����� ����. map data ����.
    	session.setAttribute("resultMsg", msg);
    	
    } else {
    	msg = "[���� ���� ����. ���� ����.] error code : " + sErrorCode + ", error message : " + sMessage;
    	
    	session.setAttribute("resultCode", "101");	// ���� ��ȣȭ ����. ���� ����. map data ����.
    	session.setAttribute("resultMsg", msg);
    	
    }
    
   	session.setAttribute("mapresult", mapresult);
    logger.error(msg);
    
 	// go to result
    String html = "<script>window.onunload = refreshParent; function refreshParent() {window.opener.location.href = \"" + resultUrl + "\";} window.close();</script>";
	out.println(html);
%>
<%!
public String requestReplace (String paramValue, String gubun) {
        String result = "";
        
        if (paramValue != null) {
        	
        	paramValue = paramValue.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

        	paramValue = paramValue.replaceAll("\\*", "");
        	paramValue = paramValue.replaceAll("\\?", "");
        	paramValue = paramValue.replaceAll("\\[", "");
        	paramValue = paramValue.replaceAll("\\{", "");
        	paramValue = paramValue.replaceAll("\\(", "");
        	paramValue = paramValue.replaceAll("\\)", "");
        	paramValue = paramValue.replaceAll("\\^", "");
        	paramValue = paramValue.replaceAll("\\$", "");
        	paramValue = paramValue.replaceAll("'", "");
        	paramValue = paramValue.replaceAll("@", "");
        	paramValue = paramValue.replaceAll("%", "");
        	paramValue = paramValue.replaceAll(";", "");
        	paramValue = paramValue.replaceAll(":", "");
        	paramValue = paramValue.replaceAll("-", "");
        	paramValue = paramValue.replaceAll("#", "");
        	paramValue = paramValue.replaceAll("--", "");
        	paramValue = paramValue.replaceAll("-", "");
        	paramValue = paramValue.replaceAll(",", "");
        	
        	if(gubun != "encodeData"){
        		paramValue = paramValue.replaceAll("\\+", "");
        		paramValue = paramValue.replaceAll("/", "");
            paramValue = paramValue.replaceAll("=", "");
        	}
        	
        	result = paramValue;
            
        }
        return result;
  }

%>
<%-- 
<html>
<head>
    <title>NICE������ - CheckPlus �Ƚɺ������� �׽�Ʈ</title>
</head>
<body>
    <center>
    <p><p><p><p>
    ���������� �����Ͽ����ϴ�.<br>
    <table border=1>
        <tr>
            <td>��ȣȭ�� �ð�</td>
            <td><%= sCipherTime %> (YYMMDDHHMMSS)</td>
        </tr>
        <tr>
            <td>��û ��ȣ</td>
            <td><%= sRequestNumber %></td>
        </tr>            
        <tr>
            <td>�������� ���� �ڵ�</td>
            <td><%= sErrorCode %></td>
        </tr>            
        <tr>
            <td>��������</td>
            <td><%= sAuthType %></td>
        </tr>
     </table><br><br>        
    <%= sMessage %><br>
    </center>
</body>
</html> --%>