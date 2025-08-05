public with sharing class BookController {
    public List<Book__c> books { get; set; }
    public Book__c newBook { get; set; }

    public BookController() {
        // Initialize a new book for form input
        newBook = new Book__c();
        
        // Load existing books
        books = [SELECT Name, Price__c, CreatedBy.Name, LastModifiedBy.Name, Owner.Name FROM Book__c];
    }

    // Method to save the new book
    public PageReference saveBook() {
        try {
            insert newBook;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Book added successfully.'));
            
            // Reset form and reload data
            newBook = new Book__c();
            books = [SELECT Name, Price__c, CreatedBy.Name, LastModifiedBy.Name, Owner.Name FROM Book__c];
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }
}
