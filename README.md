# Ruby JSON Processing Challenge

This project processes user and company data from JSON files to generate an output report ('output.txt'). The report includes token top-ups for active users associated with a company, and email notifications are triggered based on the user's and company's email status. Companies are ordered by company ID, and users are sorted alphabetically by last name.

## How to Run

1. Clone the repository:
   ```
   git clone https://github.com/YOUR_USERNAME/thrive-coding-challenge.git
   ```
   ```
   cd thrive-coding-challenge
   ```

2. Make sure 'users.json' and 'companies.json' files are present in the project directory.

3. Run the script:
   ```
   ruby challenge.rb
   ```

4. The output will be saved to 'output.txt'.

## File Structure

```
├── challenge.rb        # Main Ruby script for processing the data
├── users.json          # Example user data in JSON format
├── companies.json      # Example company data in JSON format
├── output.txt          # Generated output after running the script
```

## Example Output

```
John Doe: Top up 100 - Email sent
Jane Smith: Top up 150 - Email not sent
```
