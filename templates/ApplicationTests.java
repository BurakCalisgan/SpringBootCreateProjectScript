package {{GROUP_ID}}.{{ARTIFACT_ID}};

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class {{APPLICATION_TEST_CLASS}} {

    @Test
    void contextLoads() {
        assertThat(true).isTrue();
    }
}
