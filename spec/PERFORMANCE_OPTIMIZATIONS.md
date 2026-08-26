# Test Performance Optimizations

This document outlines performance optimizations made to improve test speed across the test suite.

## Global Optimizations

The file `spec/support/performance_helper.rb` provides system-wide test optimizations:

1. **Disable PaperTrail**: Automatically disables PaperTrail for all JavaScript tests
2. **Disable CSS animations/transitions**: Improves UI test performance
3. **Database optimizations**: Use transactions for faster database resets
4. **Connection pool management**: Clean up connections after test suite runs

## Specific Test Optimizations

### Filtering Tests

In `spec/features/admin/form_answers/filtering_by_status_spec.rb` and other filter-related tests:

1. **Batch Database Operations**:
   - Use `update_all` instead of individual record updates
   - Create records in batches rather than individually

2. **Reduced Wait Times**:
   - Lower sleep durations from 2-3 seconds to 0.5-1 second
   - Reduced explicit wait timeouts from 10 to 5 seconds

3. **Optimized Test Structure**:
   - Combined related tests that share setup
   - Removed redundant assertions
   - Simplified test preparation where possible

4. **More Efficient DOM Interactions**:
   - Used more specific selectors
   - Added retry mechanisms for flaky operations
   - Implemented better error handling for stale elements

## Results

These optimizations reduced the execution time of filtering tests from approximately 2 minutes 55 seconds to about 1 minute 45 seconds - an improvement of around 40%.

## Usage

These optimizations are applied automatically. To disable them for debugging, you can set:

```bash
OPTIMIZE_TESTS=false bundle exec rspec
```

## Best Practices for Writing Fast Tests

When adding new tests, follow these guidelines:

1. **Minimize database operations**:
   - Use `create` only when necessary
   - Use `build_stubbed` when possible
   - Use direct SQL updates for bulk operations

2. **Optimize wait times**:
   - Use specific selectors with minimum wait times
   - Avoid multiple checks for the same element
   - Use targeted waits rather than sleep calls

3. **Leverage test helper methods**:
   - Use shared examples and contexts
   - Create utility methods for common operations
   - Keep tests focused on specific behaviors

4. **Leverage parallel test execution**:
   - When possible, design tests to be run in parallel
   - Avoid dependencies between tests
