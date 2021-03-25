<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="orchestrator.orchestrator"%>
<%@page import="common.properties.PropertiesUtil"%>
<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%
	Logger logger = orchestrator.authlog;
	
	String resultUrl = PropertiesUtil.getInstance().getString("auth.resultUrl");
	
	/*=================================================================================================
	* NICE 본인인증 실패 처리
	===================================================================================================
	*/
    NiceID.Check.CPClient niceCheck = new  NiceID.Check.CPClient();
	
    java.util.HashMap mapresult = null;
    String msg = "";

    String sEncodeData = requestReplace(request.getParameter("EncodeData"), "encodeData");

    String sSiteCode = PropertiesUtil.getInstance().getString("auth.sSiteCode");		// NICE로부터 부여받은 사이트 코드
    String sSitePassword = PropertiesUtil.getInstance().getString("auth.sSitePassword");// NICE로부터 부여받은 사이트 패스워드

    String sCipherTime = "";			// 복호화한 시간
    String sRequestNumber = "";			// 요청 번호
    String sErrorCode = "";				// 인증 결과코드
    String sAuthType = "";				// 인증 수단
    String sMessage = "";
    String sPlainData = "";
    
    int iReturn = niceCheck.fnDecode(sSiteCode, sSitePassword, sEncodeData);

    if( iReturn == 0 )
    {
        sPlainData = niceCheck.getPlainData();
        sCipherTime = niceCheck.getCipherDateTime();
        
        // 데이타를 추출합니다.
        mapresult = niceCheck.fnParse(sPlainData);
        
        sRequestNumber 	= (String)mapresult.get("REQ_SEQ");
        sErrorCode 		= (String)mapresult.get("ERR_CODE");
        sAuthType 		= (String)mapresult.get("AUTH_TYPE");
    }
    else if( iReturn == -1)
    {
        sMessage = "복호화 시스템 에러입니다.";
    }    
    else if( iReturn == -4)
    {
        sMessage = "복호화 처리오류입니다.";
    }    
    else if( iReturn == -5)
    {
        sMessage = "복호화 해쉬 오류입니다.";
    }    
    else if( iReturn == -6)
    {
        sMessage = "복호화 데이터 오류입니다.";
    }    
    else if( iReturn == -9)
    {
        sMessage = "입력 데이터 오류입니다.";
    }    
    else if( iReturn == -12)
    {
        sMessage = "사이트 패스워드 오류입니다.";
    }    
    else
    {
        sMessage = "알수 없는 에러 입니다. iReturn : " + iReturn;
    }
    
    // set result info
    if ( sMessage.equals("") ) {
    	msg = "[본인 인증 실패. 사용자 에러.] error code : " + sErrorCode + ", error message : " + sMessage;

    	session.setAttribute("resultCode", "102");	// 사용자 본인인증 실패. 사용자 에러. map data 있음.
    	session.setAttribute("resultMsg", msg);
    	
    } else {
    	msg = "[본인 인증 실패. 서버 에러.] error code : " + sErrorCode + ", error message : " + sMessage;
    	
    	session.setAttribute("resultCode", "101");	// 서버 복호화 실패. 서버 에러. map data 없음.
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
    <title>NICE평가정보 - CheckPlus 안심본인인증 테스트</title>
</head>
<body>
    <center>
    <p><p><p><p>
    본인인증이 실패하였습니다.<br>
    <table border=1>
        <tr>
            <td>복호화한 시간</td>
            <td><%= sCipherTime %> (YYMMDDHHMMSS)</td>
        </tr>
        <tr>
            <td>요청 번호</td>
            <td><%= sRequestNumber %></td>
        </tr>            
        <tr>
            <td>본인인증 실패 코드</td>
            <td><%= sErrorCode %></td>
        </tr>            
        <tr>
            <td>인증수단</td>
            <td><%= sAuthType %></td>
        </tr>
     </table><br><br>        
    <%= sMessage %><br>
    </center>
</body>
</html> --%>