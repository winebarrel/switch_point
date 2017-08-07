# frozen_string_literal: true

RSpec.describe SwitchPoint::Relation do
  before do
    skip 'Support AR::Relation extension is Rails version 4 or higher.' if ActiveRecord::VERSION::MAJOR < 4

    Book.with_writable do
      Book.create!(id: 1)
    end

    Book.with_readonly do
      Book.connection.execute('INSERT INTO books (id) VALUES (99)')
    end
  end

  describe '#with_readonly' do
    context 'using take' do
      it 'connect to readonly db' do
        Book.with_writable do
          expect(Book.where(id: 1).using_readonly.count).to be_zero
        end
      end
    end

    context 'using count' do
      it 'connect to readonly db' do
        Book.with_writable do
          expect(Book.where(id: 1).using_readonly.count).to be_zero
        end
      end
    end

    context 'using update' do
      it 'connect to readonly db' do
        Book.with_writable do
          expect { Book.all.using_readonly.update(99, id: 0) }.to raise_error(SwitchPoint::ReadonlyError)
        end
      end
    end

    context 'using update_all' do
      it 'connect to readonly db' do
        Book.with_writable do
          expect { Book.all.using_readonly.update_all(id: 99) }.to raise_error(SwitchPoint::ReadonlyError)
        end
      end
    end

    context 'using delete' do
      it 'connect to readonly db' do
        Book.with_writable do
          expect { Book.all.using_readonly.delete(99) }.to raise_error(SwitchPoint::ReadonlyError)
        end
      end
    end

    context 'using delete_all' do
      it 'connect to readonly db' do
        Book.with_writable do
          expect { Book.all.using_readonly.delete_all }.to raise_error(SwitchPoint::ReadonlyError)
        end
      end
    end

    context 'using destroy' do
      it 'connect to readonly db' do
        Book.with_writable do
          expect { Book.all.using_readonly.destroy(99) }.to raise_error(SwitchPoint::ReadonlyError)
        end
      end
    end

    context 'using destroy_all' do
      it 'connect to readonly db' do
        Book.with_writable do
          expect { Book.all.using_readonly.destroy_all }.to raise_error(SwitchPoint::ReadonlyError)
        end
      end
    end

    context 'using delegation' do
      it 'connect to readonly db' do
        Book.with_writable do
          expect(Book.using_readonly.where(id: 99).count).to eq 1
        end
      end
    end
  end

  describe '#with_writable' do
    context 'using take' do
      it 'connect to writable db' do
        Book.with_readonly do
          expect(Book.where(id: 1).using_writable.take).to be_a Book
        end
      end
    end

    context 'using count' do
      it 'connect to writable db' do
        Book.with_readonly do
          expect(Book.where(id: 1).using_writable.count).to eq 1
        end
      end
    end

    context 'using update' do
      it 'connect to writable db' do
        Book.with_readonly do
          expect(Book.all.using_writable.update(1, id: 0)).to be_a Book
        end
      end
    end

    context 'using update_all' do
      it 'connect to writable db' do
        Book.with_readonly do
          expect(Book.where(id: 1).using_writable.update_all(id: 0)).to eq 1
        end
      end
    end

    context 'using delete' do
      it 'connect to writable db' do
        Book.with_readonly do
          expect(Book.all.using_writable.delete(1)).to eq 1
        end
      end
    end

    context 'using delete_all' do
      it 'connect to writable db' do
        Book.with_readonly do
          expect(Book.where(id: 1).using_writable.delete_all).to eq 1
        end
      end
    end

    context 'using destroy' do
      it 'connect to writable db' do
        Book.with_readonly do
          expect(Book.all.using_writable.destroy(1)).to be_a Book
        end
      end
    end

    context 'using destroy_all' do
      it 'connect to writable db' do
        Book.with_readonly do
          expected = [Book.where(id: 1).using_writable.take]
          expect(Book.where(id: 1).using_writable.destroy_all).to eq expected
        end
      end
    end

    context 'using delegation' do
      it 'connect to writable db' do
        Book.with_writable do
          expect(Book.using_writable.where(id: 1).count).to eq 1
        end
      end
    end
  end

  context 'without use_switch_point' do
    describe '#with_readonly' do
      it 'raises error' do
        expect { Note.all.using_readonly }.to raise_error(SwitchPoint::UnconfiguredError)
      end
    end

    describe '#using_writable' do
      it 'raises error' do
        expect { Note.all.using_writable }.to raise_error(SwitchPoint::UnconfiguredError)
      end
    end
  end
end
