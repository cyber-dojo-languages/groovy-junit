// Part of the workload the AOT cache is recorded from. It has to exist before
// any learner's kata does, so what the cache holds are the compiler's classes
// rather than any kata's, and it speeds up whatever a learner writes. It is
// shaped like a real kata all the same, a class and a test asserting against
// it, so that the same code paths are the ones that run.
class Greeter {

  String greeting() {
    'hello'
  }
}
