public with sharing class BookController {
    public List<Book__c> books { get; set; }
    public Book__c newBook { get; set; }
    public Book__c existingBook { get; set; }
    public Boolean isDuplicate { get; set; }

    public BookController() {
        newBook = new Book__c();
        isDuplicate = false;
        books = [SELECT Name, Price__c, CreatedBy.Name, LastModifiedBy.Name, Owner.Name FROM Book__c];
    }

    public PageReference saveBook() {
        try {
            // Check if a book with the same name already exists
            List<Book__c> matches = [
                SELECT Name, Price__c, CreatedBy.Name, LastModifiedBy.Name, Owner.Name 
                FROM Book__c 
                WHERE Name = :newBook.Name 
                LIMIT 1
            ];

            if (!matches.isEmpty()) {
                existingBook = matches[0];
                isDuplicate = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'A book with this name already exists!'));
                return null;
            }

            // If not duplicate, insert
            insert newBook;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Book added successfully.'));
            
            // Reset
            newBook = new Book__c();
            isDuplicate = false;
            books = [SELECT Name, Price__c, CreatedBy.Name, LastModifiedBy.Name, Owner.Name FROM Book__c];
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }
}
