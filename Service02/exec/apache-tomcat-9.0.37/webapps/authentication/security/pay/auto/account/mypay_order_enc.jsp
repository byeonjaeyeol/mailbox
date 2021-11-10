<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.google.gson.JsonParser"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="common.properties.PropertiesUtil"%>
<%@page import="orchestrator.orchestrator"%>
<%@ page contentType="text/html;charset=euc-kr" import="java.io.*,java.util.*,java.net.*"
%>
<%
	Logger logger = orchestrator.paylog;

	// get pay data from mobile
	JsonObject jsonData = new Gson().fromJson(request.getAttribute("userParam").toString(), JsonObject.class);
	logger.info(jsonData.toString());

	request.setCharacterEncoding("UTF-8");

	//-----------------------------------------------------------------------
	// 운영아이디가 발급되면 제공되는 정보 , 기본은 테스트 아이디용.
	String mhkey = PropertiesUtil.getInstance().getString("pay.mhkey");    
	String mekey = PropertiesUtil.getInstance().getString("pay.mekey");       
  	String msalt = PropertiesUtil.getInstance().getString("pay.msalt"); 

  	// 고객에게 보여지지 않는 항목
  	String servicetoken = PropertiesUtil.getInstance().getString("pay.servicetoken");
  	
  	String resultUrl = PropertiesUtil.getInstance().getString("pay.sndReply");
  	String cancelUrl = PropertiesUtil.getInstance().getString("pay.sndCancelUrl");
  	String action = PropertiesUtil.getInstance().getString("pay.action");
  	String sndCharSet     =  PropertiesUtil.getInstance().getString("pay.sndCharSet");
  	String sndThemecolor     =  PropertiesUtil.getInstance().getString("pay.sndThemecolor");
  	
  	String sndOrdernumber =  jsonData.get("sndOrdernumber").getAsString();
  	String sndStoreid     =  PropertiesUtil.getInstance().getString("pay.sndStoreid");
  	String sndCashReceipt =  jsonData.get("sndCashReceipt").getAsString();
  	
	// 고객에게 보여지는 항목
  	String sndGoodname    = jsonData.get("sndGoodname").getAsString();
  	String sndAmount      = jsonData.get("sndAmount").getAsString();
  	String sndOrdername   = jsonData.get("sndOrdername").getAsString();
  	String sndEmail       = jsonData.get("sndEmail").getAsString();
  	String sndRetParam    = jsonData.get("sndRetParam").getAsString();
  	
	// CI요청 가맹점 암호화 데이터 
  	String ci           = jsonData.get("ci").getAsString() ;   		//CI
  	String birthdate    = jsonData.get("birthdate").getAsString();    //생년월일(YYYYMMDD)
  	String gender       = jsonData.get("gender").getAsString();    // 성별구분 ( 주민번호뒤1자리)
  	String mobile       = jsonData.get("mobile").getAsString();    // 휴대전화번호.
	// ----------------------------------------------------------------------
	
	String curr_date_14 = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());
	String etoken = ksnet.kspay.MypayHostBean.get_etoken(mhkey, curr_date_14,"");
	
	StringBuffer sb = new StringBuffer();
	sb.append(curr_date_14   ).append(':');
	sb.append("servicetoken").append('=').append(servicetoken ).append('&');
	sb.append("ci").append('=').append(ci ).append('&');
	sb.append("birthdate").append('=').append(birthdate ).append('&');
	sb.append("gender").append('=').append(gender ).append('&');
	sb.append("mobile").append('=').append(mobile      ) ;
	
	String p_data = sb.toString();

	String edata = ksnet.kspay.MypayHostBean.encrypt_msg(mekey ,p_data);  // 데이터 암호화.
	
	System.out.println();
	
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
</head>
<script language="javascript">
	function _pay(_frm) 
	{
		_frm.sndReply.value=getLocalUrl('<%=resultUrl %>');
		_frm.sndCancelUrl.value=getLocalUrl('<%=cancelUrl %>');
		_frm.action ='<%=action %>';  // 운영 : https://kspay.ksnet.to/store/MYPay/MYPayWeb.jsp , 개발 : http://210.181.28.134/store/MYPay/MYPayWeb.jsp
		_frm.submit();
	}
	function getLocalUrl(mypage) 
	{ 
		var myloc = location.href; 
		return myloc.substring(0, myloc.lastIndexOf('/')) + '/' + mypage;
	} 
	
 	window.onload = function() {
		_pay(document.KSPayWeb);
	}
</script>
<body>
<!-----------------------------------------<Part 1. KSPayWeb Form: 결제요청 파라미터 설정. > ---------------------------------->
<form name="KSPayWeb" method="post" target="_self">
	<input type="hidden" name="sndMsalt" size=30  value="<%=msalt%>">
	<input type="hidden" name="sndEdata" size=30  value="<%=edata%>">
	<input type="hidden" name="sndEtoken" size=30  value="<%=etoken%>">
	<input type="hidden" name="sndOrdernumber" size=30  value="<%=sndOrdernumber%>">
	<input type="hidden" name="sndStoreid" size=30  value="<%=sndStoreid%>">
	<!-- 고객에게 보여주는 항목 -->
	<input type="hidden" name="sndGoodname" size=30  value="<%=sndGoodname%>">
	<input type="hidden" name="sndAmount" size=30  value="<%=sndAmount%>">
	<input type="hidden" name="sndOrdername" size=30  value="<%=sndOrdername%>">
	<input type="hidden" name="sndCashReceipt" size=30  value="<%=sndCashReceipt%>">
	<input type="hidden" name="sndEmail" size=30  value="<%=sndEmail%>">
	
	<input type=hidden name="sndReply"      value="" >
	<input type=hidden name="sndCancelUrl"  value="" >
	<input type=hidden name="sndRetParam"   value="<%=sndRetParam %>"> <!-- sndReply , sndCancelUrl 로 전달되어야하는 파라미터 특수문자 ' " - ` 는 사용하실수 없습니다. (따옴표,쌍따옴표,빼기,백쿼테이션)  -->
	<input type=hidden name="sndCharSet"    value="<%=sndCharSet %>">         <!-- defalut : EUC-KR -->
	<input type=hidden name="sndThemecolor"    value="<%=sndThemecolor %>">         <!-- defalut : EUC-KR -->
</form>
</body>
</html>
