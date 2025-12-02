package edu.sm.controller;

import edu.sm.app.dto.WalkPostDTO;
import edu.sm.app.service.WalkPTAiService;
import edu.sm.app.service.WalkPostService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/walkpt")
@RequiredArgsConstructor
@Slf4j
public class WalkPTChatController {

    private final WalkPTAiService walkPTAiService;
    private final WalkPostService walkPostService;

    @PostMapping("/chat")
    @SuppressWarnings("unchecked")
    public JSONObject chat(@RequestBody Map<String, String> request) {
        String query = request.get("message");
        log.info("Chat query received: {}", query);

        JSONObject response = new JSONObject();
        try {
            // 1. Analyze query with AI
            JSONObject aiResult = walkPTAiService.parseQuery(query);
            if (aiResult == null) {
                response.put("status", "error");
                response.put("message", "AI analysis failed");
                return response;
            }

            log.info("AI Analysis Result: {}", aiResult);

            // 2. Build search condition
            WalkPostDTO searchCondition = new WalkPostDTO();
            String category = (String) aiResult.get("category");
            if (category == null || category.isEmpty()) {
                category = "OWNER"; // Default
            }
            searchCondition.setCategory(category);

            String location = (String) aiResult.get("location");
            if (location != null && !location.isEmpty()) {
                searchCondition.setLocation(location);
            }

            // Use 'keyword' from AI as 'title' for search (Mapper searches title OR
            // content)
            String keyword = (String) aiResult.get("keyword");
            if (keyword != null && !keyword.isEmpty()) {
                searchCondition.setTitle(keyword);
            }

            // Date and Time might need partial matching or range search,
            // but for now we'll set them if exact match is expected or handle in SQL if
            // flexible.
            // Assuming exact match or 'contains' in Mapper for simplicity as per current
            // DTO usage.

            // 3. Search posts
            List<WalkPostDTO> posts = walkPostService.getList(searchCondition);

            // Filter out own posts
            jakarta.servlet.http.HttpSession session = ((org.springframework.web.context.request.ServletRequestAttributes) org.springframework.web.context.request.RequestContextHolder
                    .getRequestAttributes()).getRequest().getSession();
            edu.sm.app.dto.User user = (edu.sm.app.dto.User) session.getAttribute("user");
            if (user != null) {
                Integer currentUserId = user.getUserId();
                posts.removeIf(post -> post.getUserId().equals(currentUserId));
            }

            response.put("status", "success");
            response.put("aiAnalysis", aiResult);
            response.put("posts", posts);

            // Generate a conversational reply based on results
            String reply = (String) aiResult.get("reply");
            if (reply == null) {
                reply = "네, 알겠습니다.";
            }

            if (posts != null && !posts.isEmpty()) {
                reply += "\n\n검색 결과 " + posts.size() + "건을 찾았습니다.";
            } else {
                reply += "\n\n아쉽게도 조건에 맞는 글이 없습니다.";
            }
            response.put("reply", reply);

        } catch (Exception e) {
            log.error("Chat processing failed", e);
            response.put("status", "error");
            response.put("message", e.getMessage());
        }

        return response;
    }
}
