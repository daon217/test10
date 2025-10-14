package edu.sm.controller;

import edu.sm.app.springai.service1.*;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;

@RestController
@RequestMapping("/ai1")
@Slf4j
@RequiredArgsConstructor
public class Ai1Controller {

    private final AiServiceByChatClient aiService;
    private final AiServiceChainOfThoughtPrompt aiServicetp;
    private final AiServiceFewShotPrompt aiServicefsp;
    final AiServiceFewShotPrompt2 aiServiceFewShotPrompt2;
    final private AiServicePromptTemplate aiServicept;
    private final AiServicePromptTemplate aiServicePromptTemplate;
    final private AiServiceRoleAssignmentPrompt aiServicersp;
    final private AiServiceStepBackPrompt aiServicesb;

    @RequestMapping(value = "/chat-model")
    public String chatModel(@RequestParam("question") String question) {
        return aiService.generateText(question);
    }

    @RequestMapping(value = "/chat-model-stream")
    public Flux<String> chatModelStream(@RequestParam("question") String question) {
        return aiService.generateStreamText(question);
    }

    @RequestMapping(value = "/chat-of-thought")
    public Flux<String> chainOfThought(@RequestParam("question") String question) {
        return aiServicetp.chainOfThought(question);
    }

    @RequestMapping(value = "/few-shot-prompt")
    public String fewShotPrompt(@RequestParam("question") String question) {
        return aiServicefsp.fewShotPrompt(question);
    }

    @RequestMapping("/few-shot-prompt2")
    public String fewShotPrompt2(@RequestParam("question") String question) {
        return aiServiceFewShotPrompt2.fewShotPrompt2(question);
    }

    @RequestMapping(value = "/prompt-template")
    public Flux<String> promptTemplate(      @RequestParam("statement") String statement,
                                             @RequestParam("language") String language) {
        return aiServicePromptTemplate.promptTemplate3(statement, language);
    }

    @RequestMapping(value = "/role-assignment")
    public Flux<String> roleAssignment(@RequestParam("requirements") String requirements) {
        Flux<String> travelSuggestions = aiServicersp.roleAssignment(requirements);
        return travelSuggestions;
    }

    @PostMapping(value = "/step-back-prompt")
    public String stepBackPrompt(@RequestParam("question") String question) throws Exception {
        String answer = aiServicesb.stepBackPrompt(question);
        return answer;
    }
}