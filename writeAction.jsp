<%@page import="org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext"%>
<%@page import="org.apache.tomcat.util.http.fileupload.RequestContext"%>
<%@page import="org.apache.tomcat.util.http.fileupload.FileItem"%>
<%@page import="org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("utf-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page"/>
<jsp:setProperty name="bbs" property="bbsTitle"/>
<jsp:setProperty name="bbs" property="bbsContent"/>
<jsp:setProperty name="bbs" property="bbsAddress"/>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
</head>
<body>
    <%
        String userID = (String) session.getAttribute("userID");
        if (userID == null) {
            // 로그인되지 않은 상태에서의 처리
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인을 하세요')");
            script.println("location.href = 'login.jsp'");
            script.println("</script>");
        } else {
            if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null || bbs.getBbsAddress() == null){
                // 제목, 내용, 주소 중 하나라도 입력되지 않은 경우
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('모든 항목을 입력해주세요.')");
                script.println("history.back()");
                script.println("</script>");
            } else {
                // 파일 업로드 처리
                String uploadPath = ".\\uploadimg";
                // 업로드 경로 지정

                DiskFileItemFactory factory = new DiskFileItemFactory();
                ServletFileUpload upload = new ServletFileUpload(factory);

                try {
                	List<FileItem> items = upload.parseRequest((RequestContext) new ServletRequestContext(request));
                    for (FileItem item : items) {
                        if (!item.isFormField()) {
                            // 파일 필드 처리
                            String fileName = new File(item.getName()).getName();
                            String filePath = uploadPath + File.separator + fileName;
                            File storeFile = new File(filePath);

                            item.write(storeFile);
                            bbs.setImgURL(filePath);
                        } else {
                            // 일반 필드 처리
                            String fieldName = item.getFieldName();
                            String value = item.getString("UTF-8");
                            if (fieldName.equals("bbsTitle")) {
                                bbs.setBbsTitle(value);
                            } else if (fieldName.equals("bbsContent")) {
                                bbs.setBbsContent(value);
                            } else if (fieldName.equals("bbsAddress")) {
                                bbs.setBbsAddress(value);
                            }
                        }
                    }

                    BbsDAO bbsDAO = new BbsDAO();
                    int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent(), bbs.getBbsAddress(), bbs.getImgURL());
                    if(result == -1) {
                        // DB 오류 발생 시
                        PrintWriter script = response.getWriter();
                        script.println("<script>");
                        script.println("alert('글쓰기에 실패했습니다.')");
                        script.println("history.back()");
                        script.println("</script>");
                    } else {
                        // 글쓰기 성공 시
                        PrintWriter script = response.getWriter();
                        script.println("<script>");
                        script.println("location.href = 'bbs.jsp'");
                        script.println("</script>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    %>
</body>
</html>