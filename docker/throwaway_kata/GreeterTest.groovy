// The test half of the workload the AOT cache is recorded from. It passes,
// because a JVM writes a cache when it exits of its own accord and a green run
// is the simplest way to be sure of that.
import org.junit.Test
import static org.junit.Assert.assertEquals

class GreeterTest {

  @Test
  void answers_its_greeting() {
    assertEquals('hello', new Greeter().greeting())
  }
}
