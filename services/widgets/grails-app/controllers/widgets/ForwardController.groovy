package widgets;

import com.ekkitab.ui.ViewConstants;
import com.ekkitab.alog.AffilateLogger;

class ForwardController {
	static defaultAction = "send";
    def send = {
		def destUrl = params[ViewConstants.URL];
		params[ViewConstants.REQUEST] = request;
		AffilateLogger.logClick(params,request);
		redirect(url:destUrl); 
	}
}
