package web.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

import web.dto.BoardFile;

//AbstractView라는 추상클래스가 springframework 라이브러리에 있다
// 따라서 다른 설정을 해주는 것이 아닌 import만 하면 기능을 쓸 수 있다
public class DownloadView extends AbstractView{
	
	private static final Logger logger = LoggerFactory.getLogger(DownloadView.class);
	
	//서블릿컨텍스트 객체
	@Autowired
	ServletContext context;
	
	@Override
	protected void renderMergedOutputModel(
			Map<String, Object> model, 
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("DownloadView 요청 완료");
		
		logger.info("model객체 데이터 : {}", model);
		logger.info(model.toString());
		
	    
		
		//모델값 가져오기
		BoardFile file = (BoardFile) model.get("downFile");
		logger.info("모델값 : {}", file);
		
		//파일의 경로
		String path = context.getRealPath("resources");
		
		//저장된 파일의 이름
		String filename = file.getBfStoredName();
		
		//업로드된 실제 파일에 대한 객체
		File src = new File(path, filename);
		
		logger.info("서버에 업로드된 파일 : {}", src);
		logger.info("파일의 존재 여부 : {}", src.exists());
		
		//--------------------------------------------------
		
		//어떤 형식이든지 파일로 바꾸면 2진 데이터 형태가 된다
		// application/octet-stream -> 2진 데이터 처리타입
		// octet - 8bit
		//파일을 전송하는 컨텐트타입으로 설정한다 (2진데이터 형식)
		//파일 형식에 구애받지말고 다운받을 땐 application/octet-stream을 쓴다
		response.setContentType("application/octet-stream");
		
		//응답 데이터의 크기 설정
		// 2GB를 안넘으면 int를 써도 되지만, 대용량일 경우 int를 쓰면 안된다
		response.setContentLength( (int) src.length() );
		
		//응답 데이터의 인코딩 설정
		response.setCharacterEncoding("UTF-8");
		
		//클라이언트가 파일을 저장할 때 사용할 이름에 대한 인코딩 설정(UTF-8)
		String outputName
		 = URLEncoder.encode( file.getBfOriginName(), "UTF-8");
		logger.info("변환된 파일명 : {}", outputName);
		
		//브라우저가 다운로드에 사용할 이름을 지정하기
		response.setHeader("Content-Disposition"
				, "attachment; filename=\"" + outputName + "\"");
		
		//-------------------------------------------------------
		
		//응답 데이터 전송
		//	서버의 File -> FileInputStream -> Response OutputStream으로 출력
		
		//서버에 저장된 파일 객체
//		File stored = src;
		File stored = new File( 
				context.getRealPath("resources")
				, file.getBfStoredName() );
		
		logger.info("서버에 업로드된 파일 : {}", stored);
		logger.info("파일의 존재 여부 : {}", stored.exists());
		
		//서버에 저장된 파일 입력스트림
		FileInputStream fis = new FileInputStream(stored);
		
		//서버 응답 출력스트림
		OutputStream out = response.getOutputStream();
		
		//서버 -> 클라이언트 파일 복사
		FileCopyUtils.copy(fis, out);
		
	}
	
}
