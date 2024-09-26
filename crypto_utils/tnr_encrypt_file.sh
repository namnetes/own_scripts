#!/bin/bash
#
# tnr_encrypt_file.sh - Automated non-regression tests for encrypt_file.sh
#
# Test Cases:
#   - Test 1: Encrypt a known file and verify the output file is created.
#   - Test 2: Encrypt with missing input file (should fail).
#   - Test 3: Encrypt with an invalid output file path (should fail).
#   - Test 4: Help option should display usage information.
#

# Test data
TEST_INPUT_FILE="test_data.txt"
TEST_ENCRYPTED_FILE="test_data.enc"

# Variable to track failures
FAILED_TESTS=0

# Separator function for readability
print_separator() {
    printf -v line '%*s' "$COLUMNS" ''
    echo -e "\n${line// /-}\n"
}

# Function to create a simple test file
setup_test_data() {
    echo "This is a test file for encryption." > "$TEST_INPUT_FILE"
}

# Request the password once
read -sp "Enter the encryption password: " PASSWORD
echo
echo "debug:$PASSWORD"
# Test 1: Encrypt a known file and check if the output file is created
test_encrypt_file_creation() {
    print_separator
    echo "Running Test 1: Encrypt file and check output creation"
    ./encrypt_file.sh -f "$TEST_INPUT_FILE" -o "$TEST_ENCRYPTED_FILE" -p "$PASSWORD"
    if [ -f "$TEST_ENCRYPTED_FILE" ]; then
        echo "Test 1 Passed: Encrypted file '$TEST_ENCRYPTED_FILE' created successfully."
    else
        echo "Test 1 Failed: Encrypted file '$TEST_ENCRYPTED_FILE' not created."
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Test 2: Encrypt with missing input file (should fail)
test_missing_input_file() {
    print_separator
    echo "Running Test 2: Encrypt with missing input file"
    ./encrypt_file.sh -f "non_existent.txt" -o "$TEST_ENCRYPTED_FILE" -pass pass:"$PASSWORD" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "Test 2 Passed: Missing input file handled correctly."
    else
        echo "Test 2 Failed: Script did not handle missing input file."
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Test 3: Encrypt with an invalid output file path (should fail)
test_invalid_output_file() {
    print_separator
    echo "Running Test 3: Encrypt with invalid output file path"
    ./encrypt_file.sh -f "$TEST_INPUT_FILE" -o "/invalid/output/path.enc" -pass pass:"$PASSWORD"
    if [ $? -ne 0 ]; then
        echo "Test 3 Passed: Invalid output file path handled correctly."
    else
        echo "Test 3 Failed: Script did not handle invalid output file path."
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Test 4: Help option should display usage information
test_help_option() {
    print_separator
    echo "Running Test 4: Check help option"
    ./encrypt_file.sh -h > help_output.txt
    if grep -q "Usage:" help_output.txt; then
        echo "Test 4 Passed: Help option displays usage information correctly."
    else
        echo "Test 4 Failed: Help option did not display correct information."
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
    rm help_output.txt
}

# Main testing function
run_tests() {
    setup_test_data
    test_encrypt_file_creation
    test_missing_input_file
    test_invalid_output_file
    test_help_option
}

# Clean up function to remove test files
cleanup() {
    print_separator
    echo "Cleaning up test files..."
    rm -f "$TEST_INPUT_FILE" "$TEST_ENCRYPTED_FILE"
}

# Run all tests
run_tests

# Cleanup after tests
cleanup

# Check if any tests failed
if [ $FAILED_TESTS -ne 0 ]; then
    echo -e "\n$FAILED_TESTS test(s) failed.\n"
    exit 1
else
    echo -e "\nAll tests passed successfully.\n"
fi
