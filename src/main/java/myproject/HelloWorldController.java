import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {
    @GetMapping("/hello") // This endpoint should match the URL you access
    public String sayHello() {
        return "Hello, World!";
    }
}
